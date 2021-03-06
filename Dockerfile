FROM php:7.0-fpm

# Install modules
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libicu-dev \
            --no-install-recommends

RUN docker-php-ext-install mcrypt zip intl mbstring pdo_mysql exif \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN pecl install -o -f xdebug \
    && rm -rf /tmp/pear

COPY ./php.ini /usr/local/etc/php/
COPY ./www.conf /usr/local/etc/php/

RUN apt-get purge -y g++ \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN usermod -u 1000 www-data

EXPOSE 9000
CMD ["php-fpm"]

# Add composer
#RUN php -r "copy('https://getcomposer.org/composer.phar', 'composer.phar');" \
#    && mv composer.phar /bin/composer \
#    && chmod 777 /bin/composer

RUN apt-get update \
    && apt-get install -y zlibc \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /bin/composer \
    && chmod 777 /bin/composer
    
# syn date for cn
# RUN apt-get install -y ntpdate \
#    && cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
#    && ntpdate cn.pool.ntp.org > null \
#    && date
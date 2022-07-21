FROM php:8.1-fpm as base

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update && \
    apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

RUN apt-get install libaio-dev mc unzip zlib1g-dev libmemcached-dev --no-install-recommends --no-install-suggests -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

FROM base as dev

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
COPY ${PHP_CONFIG_FOLDER}/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN cd /home/${PROJECT_DIR} && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');"


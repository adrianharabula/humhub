FROM php:7.4.4-apache-buster
LABEL maintainer="adrian.harabula@gmail.com"

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libicu-dev \
        libldap2-dev \
        cron \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip pdo_mysql exif intl ldap

RUN printf "file_uploads = On\nupload_max_filesize = 64M\npost_max_size = 64M\nmax_execution_time = 600\n" > $PHP_INI_DIR/conf.d/php-custom.ini
RUN printf "SHELL=/bin/bash\nBASH_ENV=/container.env\n* * * * * /usr/local/bin/php /var/www/html/protected/yii cron/run >/dev/null 2>&1\n# This extra line makes it a valid cron\n" > /etc/cron.d/humhub

RUN a2enmod rewrite

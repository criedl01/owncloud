FROM php:7.1-apache
RUN apt-get update && apt-get -y install wget vim net-tools supervisor libgd-dev libgd3 libpng-dev libfreetype6-dev libjpeg62-turbo-dev ssl-cert libicu-dev sudo libzip-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-configure zip --with-libzip=/usr/include/ \
 && docker-php-ext-install gd \
 && docker-php-ext-install zip \
 && docker-php-ext-install pdo_mysql intl
RUN wget -O /tmp/owncloud.tar.bz2 https://download.owncloud.org/community/owncloud-10.0.9.tar.bz2
RUN mkdir -p /srv
WORKDIR /srv
RUN tar xjf /tmp/owncloud.tar.bz2
ADD usr/local/sbin /usr/local/sbin
WORKDIR /var/www/html/
RUN ln -s /srv/owncloud/ ./files
RUN mkdir -p /srv/owncloud/data
RUN chown -R www-data.www-data /srv/owncloud
RUN chown -R www-data.www-data /srv/owncloud/config
RUN a2enmod ssl
RUN ln -s ../sites-available/default-ssl.conf /etc/apache2/sites-enabled/
WORKDIR /srv/owncloud/

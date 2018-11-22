FROM  alpine
MAINTAINER Hamza BENDALI BRAHAM [ hbendali@ya.ru ]

RUN adduser -D -g 'nginx' nginx

RUN apk update
RUN apk upgrade
RUN apk add openrc

RUN mkdir -p /srv/www 
RUN echo "<?php phpinfo(); ?>">/srv/www/phpinfo.php
RUN wget https://github.com/vrana/adminer/releases/download/v4.6.3/adminer-4.6.3-mysql-en.php -O /srv/www/adminer.php
RUN chown -R nginx:nginx /srv/www

RUN mkdir -p /srv/database


# ========
#  NGINX
# ========
RUN apk add nginx
RUN rc-update add nginx default

# ======
#  PHP 
# ======
RUN apk add \
php7-fpm \
php7-mcrypt \
php7-soap \
php7-openssl \
php7-gmp \
php7-pdo_odbc \
php7-json \
php7-dom \
php7-pdo \
php7-zip \
php7-mysqli \
php7-sqlite3 \
php7-apcu \
php7-pdo_pgsql \
php7-bcmath \
php7-gd \
php7-odbc \
php7-pdo_mysql \
php7-pdo_sqlite \
php7-gettext \
php7-xmlreader \
php7-xmlrpc \
php7-bz2 \
php7-iconv \
php7-pdo_dblib \
php7-curl \
php7-ctype

RUN PHP_FPM_USER="nginx"
RUN PHP_FPM_GROUP="nginx"
RUN PHP_FPM_LISTEN_MODE="0660"
RUN PHP_MEMORY_LIMIT="512M"
RUN PHP_MAX_UPLOAD="50M"
RUN PHP_MAX_FILE_UPLOAD="200"
RUN PHP_MAX_POST="100M"
RUN PHP_DISPLAY_ERRORS="On"
RUN PHP_DISPLAY_STARTUP_ERRORS="On"
RUN PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
RUN PHP_CGI_FIX_PATHINFO=0

RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.conf
RUN sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.conf
RUN sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.conf
RUN sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.conf
RUN sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.conf
RUN sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.conf #uncommenting line 
RUN sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini
RUN sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini
RUN sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini
RUN sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini
RUN sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini
RUN sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini
RUN sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini
RUN sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini

RUN rc-update add php-fpm7 default

#ENTRYPOINT ["mysql"]
##RUN echo "root:Docker!" | chpasswd

WORKDIR /srv/www
EXPOSE 80
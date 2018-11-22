FROM  alpine
MAINTAINER Hamza BENDALI BRAHAM [ hbendali@ya.ru ]

ENV PHP_NGINX_USER="www"
ENV PHP_NGINX_GROUP="www"

ENV PHP_VARS="/etc/php7/conf.d/docker-vars.ini"
ENV PHP_INI="/etc/php7/php.ini"
ENV PHP_CONF="/etc/php7/php-fpm.conf"
ENV FPM_CONF="/etc/php7/php-fpm.d/www.conf"

ENV PHP_FPM_LISTEN_MODE="0660"
ENV PHP_MEMORY_LIMIT="512M"
ENV PHP_MAX_UPLOAD="50M"
ENV PHP_MAX_FILE_UPLOAD="200"
ENV PHP_MAX_POST="100M"
ENV PHP_DISPLAY_ERRORS="On"
ENV PHP_DISPLAY_STARTUP_ERRORS="On"
ENV PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
ENV PHP_CGI_FIX_PATHINFO=0

# ============
#  NGINX PHP 
# ============
# Install build dependencies for docker-gen

RUN apk add --no-cache \
    ca-certificates \
    openrc \
    openssh \
    openssl \
    #yaml \
    #pcre \
    #libmemcached-libs \
    zlib \
    curl \
    #gcc \
    #git \
    #make \
    #musl-dev \
    sqlite \
    nginx \
    php7 \
    php7-apcu \
    php7-bcmath \
    php7-bz2 \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fpm \
    php7-gd \
    php7-gettext \
    php7-gmp \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-mcrypt \
    php7-mysqli \
    php7-mysqlnd \
    php7-odbc \
    php7-opcache \
    php7-openssl \
    php7-pdo \
    php7-pdo_dblib \
    php7-pdo_mysql \
    php7-pdo_odbc \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-pgsql \
    php7-phar \
    php7-phpdbg \
    php7-posix \
    php7-session \
    php7-soap \
    php7-sockets \
    php7-sqlite3 \
    php7-xmlreader \
    php7-xmlrpc \
    php7-zip
  
RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_NGINX_USER}|g" ${PHP_CONF} && \
    sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_NGINX_GROUP}|g" ${PHP_CONF} && \
    sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" ${PHP_CONF} && \
    sed -i "s|user\s*=\s*nobody|user = ${PHP_NGINX_USER}|g" ${PHP_CONF} && \
    sed -i "s|group\s*=\s*nobody|group = ${PHP_NGINX_GROUP}|g" ${PHP_CONF} && \
    sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" ${PHP_CONF} && \
    sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" ${PHP_INI} && \
    sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" ${PHP_INI} && \
    sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" ${PHP_INI} && \
    sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" ${PHP_INI} && \
    sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" ${PHP_INI} && \
    sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" ${PHP_INI} && \
    sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" ${PHP_INI} && \
    sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini

# tweak php-fpm config
RUN echo "cgi.fix_pathinfo=${PHP_CGI_FIX_PATHINFO}" > ${PHP_VARS} &&\
    echo "upload_max_filesize = ${PHP_MEMORY_LIMIT}"  >> ${PHP_VARS} &&\
    echo "post_max_size = 100M"  >> ${PHP_VARS} &&\
    echo "variables_order = \"EGPCS\""  >> ${PHP_VARS} && \
    echo "memory_limit = ${PHP_MEMORY_LIMIT}"  >> ${PHP_VARS} && \
    sed -i \
        -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
        -e "s/pm.max_children = 5/pm.max_children = 4/g" \
        -e "s/pm.start_servers = 2/pm.start_servers = 3/g" \
        -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" \
        -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" \
        -e "s/;pm.max_requests = 500/pm.max_requests = 200/g" \
        -e "s/user = www-data/user = ${PHP_NGINX_USER}/g" \
        -e "s/group = www-data/group = ${PHP_NGINX_GROUP}/g" \
        -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
        -e "s/;listen.owner = www-data/listen.owner = ${PHP_NGINX_USER}/g" \
        -e "s/;listen.group = www-data/listen.group = ${PHP_NGINX_GROUP}/g" \
        -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" \
        -e "s/^;clear_env = no$/clear_env = no/" \
        /etc/php7/php-fpm.d/www.conf

RUN mkdir -p /srv/sqlite && \
    mkdir -p /srv/www  && \
    wget https://github.com/vrana/adminer/releases/download/v4.6.3/adminer-4.6.3-mysql-en.php -O /srv/www/adminer.php && \
    echo "<?php phpinfo(); ?>">/srv/www/phpinfo.php && \
    adduser -D -g ${PHP_NGINX_USER} ${PHP_NGINX_GROUP} && \
    chown -R ${PHP_NGINX_USER}:${PHP_NGINX_GROUP} /srv

COPY nginx.conf /etc/nginx/nginx.conf

RUN rc-update add nginx default && \
    rc-update add php-fpm7 default


WORKDIR /srv
EXPOSE 80
EXPOSE 443

CMD ["php-fpm7", "nginx"]
FROM  alpine
MAINTAINER Hamza BENDALI BRAHAM [ hbendali@ya.ru ]

ENV PHP_FPM_USER                www
ENV PHP_FPM_GROUP               www
ENV PHP_FPM_LISTEN_MODE         0660
ENV PHP_MEMORY_LIMIT            512M
ENV PHP_MAX_UPLOAD              50M
ENV PHP_MAX_FILE_UPLOAD         200
ENV PHP_MAX_POST                100M
ENV PHP_DISPLAY_ERRORS          On
ENV PHP_DISPLAY_STARTUP_ERRORS	On
ENV PHP_ERROR_REPORTING         "E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
ENV PHP_CGI_FIX_PATHINFO        0

# ====================
#  Install NGINX PHP 
# ====================
# Install build dependencies for docker-gen
RUN set -ex && \
    apk add --no-cache \
    ca-certificates \
    openssh \
    yaml \
    pcre \
    libmemcached-libs \
    zlib \
    curl \
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

RUN apk add tzdata

RUN mkdir -p /srv/docker /srv/www
RUN adduser -D -g 'www' www

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY docker/ /srv/docker/
COPY www/ /srv/www/
RUN  chown -R www:www /var/lib/nginx /srv 

WORKDIR /srv
VOLUME ["/srv/www"]
EXPOSE 80

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD php-fpm7 -D && nginx -g 'daemon off;'
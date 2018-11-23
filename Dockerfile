FROM  alpine
MAINTAINER Hamza BENDALI BRAHAM [ hbendali@ya.ru ]

ENV UID                     100
ENV GID                     101
ENV MEMORY_LIMIT            256M
ENV MAX_EXECUTION_TIME      60
ENV UPLOAD_MAX_FILESIZE     64M
ENV MAX_FILE_UPLOADS        20
ENV POST_MAX_SIZE           64M
ENV MAX_INPUT_VARS          4000
ENV DATE_TIMEZONE           Asia/Shanghai
ENV PM_MAX_CHILDREN         6
ENV PM_START_SERVERS        4
ENV PM_MIN_SPARE_SERVERS    2
ENV PM_MAX_SPARE_SERVERS    6

# ====================
#  Install NGINX PHP 
# ====================
# Install build dependencies for docker-gen
RUN set -ex && \
    apk add --no-cache \
    ca-certificates \
    #openrc \
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
    lighttpd \
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

RUN mkdir -p /srv/sqlite /srv/www /var/lib/lighttpd/cache/compress /srv/www/d
RUN adduser -D -g www www

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY mod_fastcgi.conf /etc/lighttpd/mod_fastcgi.conf
COPY www/ /srv/www/
RUN  chown -R www:www /srv /var/lib/lighttpd/cache/compress

WORKDIR /srv
#VOLUME ["/srv/sqlite"]
#VOLUME ["/srv/www"]
EXPOSE 80

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD php-fpm7 -D && lighttpd -D -f /etc/lighttpd/lighttpd.conf
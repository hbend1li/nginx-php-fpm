#! /bin/sh
#
# entrypoint.sh

set -e

[[ "$DEBUG" == "true" ]] && set -x

# sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.conf
# sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.conf
# sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.conf
# sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.conf
# sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.conf
# sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.conf #uncommenting line 
# sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini
# sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini
# sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini
# sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini
# sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini
# sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini
# sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini
# sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini
# sed -i "s|listen\s*=\s*127.0.0.1:9000|listen = \/var\/run\/php-fpm.sock|g" /etc/php7/php.ini

sed -i \
-e "s|;log_level\s*=\s*notice|log_level = notice|g" \
/etc/php7/php-fpm.conf 

sed -i \
-e "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" \
-e "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" \
-e "s|listen\s*=\s*127.0.0.1:9000|listen = \/var\/run\/php-fpm.sock|i" \
-e "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" \
-e "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" \
-e "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" \
/etc/php7/php-fpm.d/www.conf

sed -i \
-e "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" \
-e "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" \
-e "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" \
-e "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" \
-e "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" \
-e "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" \
-e "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" \
-e "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" \
/etc/php7/php.ini

#addgroup -g ${GID} -S www && adduser -u ${UID} -G www -H -D -s /sbin/nologin www
#mkdir -p /var/lib/lighttpd/cache/compress /srv/www /srv/sqlite
#chown www:www -R /var/lib/lighttpd/cache/compress /srv

TIMEZONE="Europe/Helsinki"
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
echo "${TIMEZONE}" > /etc/timezone
sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini

exec "$@"
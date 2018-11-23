#! /bin/sh
#
# entrypoint.sh

set -e

[[ "$DEBUG" == "true" ]] && set -x

cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
echo "${TIMEZONE}" > /etc/timezone

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
  -e "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" \
  /etc/php7/php.ini

exec "$@"
FROM php:8.0-fpm-alpine

# Install additional PHP extensions,
# "mlocati/php-extension-installer" provides an easy way to install extensions
# see https://github.com/mlocati/docker-php-extension-installer/blob/master/README.md
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions apcu gd opcache pdo_mysql uploadprogress

RUN set -e; \
  # Use the default dev configuration
  mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
  # PHP-FPM logs to Standard Out/Error so turn off logging to Nginx FastCSG
  { \
    echo; \
    echo "; Turn off FastCGI logging so that Nginx doesn't also log what we are already logging"; \
    echo "php_admin_flag[fastcgi.logging] = off"; \
  } | tee -a "$PHP_INI_DIR"/../php-fpm.d/docker.conf

# Install Drush Launcher
RUN set -e \
  cd /usr/local/bin; \
	curl -o drush -OL https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar ;\
	chmod +x drush

WORKDIR "/app"
EXPOSE 9000
USER www-data

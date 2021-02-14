# Starting building the main image which will contain the Composer executable
FROM php:7.4-alpine

# Install additional PHP extensions which Drupal requires,
# "mlocati/php-extension-installer" provides an easy way to install extensions
# see https://github.com/mlocati/docker-php-extension-installer/blob/master/README.md
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd

# Use the default dev configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Copy Crontab files into the image
COPY crontabs/www-data /etc/crontabs

# Copy the specially written Drupal Cron PHP script into the iamge
COPY drupal-cron-run.php /
RUN chmod +x /drupal-cron-run.php

WORKDIR "/var/www/app"

CMD ["crond", "-f"]

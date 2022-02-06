# Starting building the main image which will contain the Composer executable
FROM php:8.0-alpine

# Install additional PHP extensions which Drupal requires,
# "mlocati/php-extension-installer" provides an easy way to install extensions
# see https://github.com/mlocati/docker-php-extension-installer/blob/master/README.md
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions apcu gd opcache pdo_mysql uploadprogress

# Use the default dev configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Add supercronic to this image, using the `hectormolinero/supercronic` image.
# Supercronic itself does not provide an image we can pull from, so we use
# `hectormolinero/supercronic` which does the work for us and Docker will
# provide the correct binary based on our platform requirements.
COPY --from=hectormolinero/supercronic /usr/bin/supercronic /usr/local/bin/

# Copy Crontab files into the image
COPY crontab /etc/

# Copy the specially written Drupal Cron PHP script into the iamge
COPY drupal-cron-run.php /
RUN chmod +x /drupal-cron-run.php

WORKDIR "/app"
USER www-data

# Use `supercronic` as the entry point and pass the crontab file to
# `supercronic`.
ENTRYPOINT [ "/usr/local/bin/supercronic" ]
CMD [ "/etc/crontab" ]

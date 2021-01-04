# Starting building the main image which will contain the Composer executable
FROM php:7.4-alpine

# Use the default dev configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Install additional PHP extensions which Drupal requires,
# "mlocati/php-extension-installer" provides an easy way to install extensions
# see https://github.com/mlocati/docker-php-extension-installer/blob/master/README.md
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd

# Copy the Composer binary from the Composer image on Docker Hub
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# The default command, this will usually be overriden at runtime by whatever composer
# sub-command the user wants to run.
CMD [ "composer" ]

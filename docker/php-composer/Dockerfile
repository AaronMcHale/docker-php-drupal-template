# Starting building the main image which will contain the Composer executable
FROM php:8.0-alpine

# Install additional PHP extensions which Drupal requires,
# "mlocati/php-extension-installer" provides an easy way to install extensions
# see https://github.com/mlocati/docker-php-extension-installer/blob/master/README.md
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions apcu gd opcache pdo_mysql uploadprogress

# Use the default dev configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Install dependencies that are required by Composer, the entrypoint script, or are
# generally used during normal operations.
# - tini: used by entrypoint.sh
# - git openssh: for pulling Composer repos using Git
# - zip unzip: for packing/unpacking Composer packages that use zip
# - patch: if we need to have Composer patch some of the codebase using patch files
RUN set -e; \
  apk add --no-cache \
  tini \
  git openssh-client \
  zip unzip \
  patch

# Copy the Composer binary from the Composer image on Docker Hub
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Also copy Composer Entry Point script from image and use that
COPY --from=composer:2 /docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Use /tmp for storing Composer Cache files
ENV COMPOSER_HOME /tmp

# The default command, this will usually be overriden at runtime by whatever composer
# sub-command the user wants to run.
CMD [ "composer" ]

FROM php:8.2-fpm-alpine

# Install additional PHP extensions,
# "mlocati/php-extension-installer" provides an easy way to install extensions
# see https://github.com/mlocati/docker-php-extension-installer/blob/master/README.md
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions apcu gd opcache pdo_mysql uploadprogress

RUN set -e; \
  # Use production php.ini config. Settings like error reporting and display are
  # managed separately by Drupal and each CLI utility.
  cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
  # PHP-FPM logs to Standard Out/Error so turn off logging to Nginx FastCSG
  { \
    echo; \
    echo "; Turn off FastCGI logging so that Nginx doesn't also log what we are already logging"; \
    echo "php_admin_flag[fastcgi.logging] = off"; \
  } | tee -a "$PHP_INI_DIR"/../php-fpm.d/docker.conf

COPY "3445816-install-with-env.ini" $PHP_INI_DIR/conf.d

# Install dependencies that are required by Composer, the entrypoint script, or are
# generally used during normal operations.
# - tini: used by the cli-docker-entrypoint.sh script
# - git openssh: for pulling Composer repos using Git
# - zip unzip: for packing/unpacking Composer packages that use zip
# - patch: if we need to have Composer patch some of the codebase using patch files
# - mysql-client: used by Drush for commands like sql-dump, site-install, etc
# - bash: used by Drush to run other commands like mysqldump, when using sql-dump, etc
# - rsync: used by Drush when syncing database, e.g. from production server to localhost
RUN set -e; \
  apk add --no-cache \
  tini \
  git openssh-client \
  zip unzip \
  patch \
  mysql-client \
  bash \
  rsync

# Copy the cli-docker-entrypoint.sh script
COPY cli-docker-entrypoint.sh /
RUN chmod +x /cli-docker-entrypoint.sh

# Copy Composer and the entrypoint script from the Composer image on Docker Hub
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
COPY --from=composer:2 /docker-entrypoint.sh /usr/local/bin/composer-entrypoint.sh

# Use /tmp for storing Composer Cache files
ENV COMPOSER_HOME /home/composer

# Add supercronic to this image, using the `hectormolinero/supercronic` image.
# Supercronic itself does not provide an image we can pull from, so we use
# `hectormolinero/supercronic` which does the work for us and Docker will
# provide the correct binary based on our platform requirements.
COPY --from=hectormolinero/supercronic /usr/bin/supercronic /usr/local/bin/

WORKDIR "/app"
EXPOSE 9000
USER www-data

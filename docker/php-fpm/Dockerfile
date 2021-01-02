FROM php:7.4 AS composer-install
COPY composer-install.sh .
RUN chmod +x composer-install.sh; /composer-install.sh

FROM php:7.4-fpm-alpine

# Install additional PHP extensions,
# "mlocati/php-extension-installer" provides an easy way to install extensions
# see https://github.com/mlocati/docker-php-extension-installer/blob/master/README.md
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd

# Use the default dev configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Install Composer
COPY --from=composer-install composer.phar /usr/local/bin/composer

# Install Drush Launcher
RUN cd /usr/local/bin; \
	curl -o drush -OL https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar ;\
	chmod +x drush

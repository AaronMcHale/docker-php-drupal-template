#!/usr/bin/env sh
# This script runs through a Docker build and fully Drupal installation to act as a
# sort of "end to end" set of tests. Instead of mounting directories such as `app`
# inside the containers, instead the `.test-temp` folder (adjacent to this script)
# is used to store equivalent temporary mounted directories.

# Remove the `.test-temp` directory if it exists and create a clean one.
if [ -d .test-temp ]; then
    rm -rf .test-temp
    if [ $? != 0 ]; then
        echo "Could not remove .test-temp directory recursively, check file permissions, aborting."; exit 1
    fi
fi
mkdir .test-temp
mkdir .test-temp/app
mkdir .test-temp/composer

# Define common arguments that we pass to Docker Compose
# We are using the Overrides method here: `-f ../docker-compose.yml`
# is our main Compose file, then `-f docker-compose.yml` contains
# test specific values which override values in our main Compose file
compose_args="-f ../docker-compose.yml -f docker-compose.yml --project-name crm_test"

docker_compose_cleanup()
{
    echo 'Attempting to clean up...'
    docker-compose $compose_args stop
    docker-compose $compose_args kill
    docker-compose $compose_args rm --force -v
    docker rmi --force "crm_php_composer_test"
    rm -rf .test-temp
    echo 'Done'
}

docker-compose $compose_args build --no-cache
if [ $? != 0 ]; then
    echo "Failed to build images from Compose files, aborting."
    docker_compose_cleanup; exit 1
fi
docker-compose $compose_args up -d --force-recreate
if [ $? != 0 ]; then
    echo "Failed to start containers from Compose files, aborting."
    docker_compose_cleanup; exit 1
fi

# Build the Composer image, don't use cache
docker build -t "crm_php_composer_test" "../php-composer" --no-cache
if [ $? != 0 ]; then
    echo "Failed to build PHP Composer image, aborting."
    docker_compose_cleanup; exit 1
fi

export COMPOSER_HOME=$PWD/.test-temp/composer
export COMPOSER_APP_DIR=$PWD/.test-temp/app
export COMPOSER_CONTAINER_NAME=crm_php_composer_test

../../composer create-project --no-interaction drupal/recommended-project .
if [ $? != 0 ]; then
    echo "Failed to install Drupal, aborting."
    docker_compose_cleanup; exit 1
fi

# Cleanup
docker_compose_cleanup

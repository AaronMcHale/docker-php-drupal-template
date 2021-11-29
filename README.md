# Docker PHP Drupal Template project

This is a template for starting a Drupal and PHP project/website running on Docker.

This template project is designed to provide a quick start approach to getting set up quickly with minimal effort required.

This template is not just for the development process, it is being architected in a way which supports a project moving through multiple environments: from dev, through test and eventually to the live production environment.

When you use this template, you're first instinct will be to scrap this README file, however it has some useful info, so consider building on it instead of replacing it :)

## First run and usage

Run `make` to build the Docker images, you will need to run this on:
* first time you setup a new system/environment
* make changes to any of the Dockerfiles and associated files
* rename the project directory, the name of this directory is used as part of the name of the built images and containers

Run `./composer install` Composer will read the supplied `composer.json` and install all dependencies, including Drupal Core. You will need to do this each time you set up a new environment/system, and after any of the dependencies in the `composer.json` have been updated.

Note: When starting from scratch using this template, it is not necessary to run `./composer create-project`, simply run `./composer install`, a `composer.json` is provided based on `drupal/recommended-project` for your convenience.

Run `./docker-compose up -d` to start the containers that run in Docker Compose (e.g. Nginx, PHP-FPM, etc). To run any other Docker Compose command, use the `./docker-compose`.

It is encouraged and sometimes necessary to customise any and all of the Dockerfiles, Compose files and configuration shipped with this template.

## Key files and directories

* `./composer`: Executable shell script to run PHP Composer in a Container, any arguments/params passed to the script will be forwarded to Composer running inside the container. Treat it as a regular Composer PHAR, e.g. `./composer require ...` will work as expected, however note that (for now) Composer itself is not aware of which directory you are in, it will always run from the top level directory.
* `./docker-compose`: Executable shell script to run Docker Compose commands, passing commands to this script is the recommended way as it sets up the environment properly for Docker Compose, running `docker-compose` directly will require you to pass in the relevant environment information manually, this wrapper script will do it for you.
* `docker/`: Stores files for building and running the Docker Images and Containers, e.g. docker-compose files, Dockerfiles, Nginx configuration, etc.
* `vendor/`: Where dependencies installed through Composer live. Mounted inside Docker containers as `/app/vendor`.
* `web/`: The Drupal HTTP web root, where you'll find `modules/`, `themes/`, etc. Mounted inside Docker containers as `/app/web`.
* `Makefile`: Tasks for building images and setting up the environment, executed by running `make`.
* `example.env` and `.env`: Used to set environment variables.
* `.gitignore`: Customise this as you see fit, it ships with some sensible defaults.
* `.editorconfig` and `.gitattributes`: The Drupal-shipped versions.

## Docker

[Refer to the README.md in the docker directory for more details and documentation.](docker/README.md)

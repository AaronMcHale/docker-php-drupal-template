# Docker PHP Drupal Template project

This is a template for starting a Drupal and PHP project/website running on Docker.

This template project is designed to provide a quick start approach to getting set up quickly with minimal effort required.

This template is not just for the development process, it is being architected in a way which supports a project moving through multiple environments: from dev, through test and eventually to the live production environment.

When you use this template, you're first instinct will be to scrap this README file, however it has some useful info, so consider building on it instead of replacing it :)

## First run and usage

Copy the `example.env` file and name it `.env`, ensure that the `ENVIRONMENT` environment variable is set appropriately. See the comments in `example.env` for more information.

Before running any Docker commands, source the `env.sh` script, run:
```
. env.sh
```
This will export the required environment variables to your shell.

Run `make` to build the Docker images, you will need to run this on:
* first time you setup a new system/environment
* make changes to the Dockerfiles and associated files
* rename the project directory, the name of this directory is used as part of the name of the built images and containers

Run `make install` or `./cli composer install` Composer will read the supplied `composer.json` and install all dependencies, including Drupal Core. You will need to do this each time you set up a new environment/system, and after any of the dependencies in the `composer.json` have been updated.

Note: When starting from scratch using this template, it is not necessary to run `./cli composer create-project`, simply run `./cli composer install`, a `composer.json` is provided based on `drupal/recommended-project` for your convenience.

Run `make up` or `docker compose up -d` to start the containers that run in Docker Compose (e.g. Nginx, PHP-FPM, etc).

It is encouraged and sometimes necessary to customise any and all of the Dockerfiles, Compose files and configuration shipped with this template.

## Key files and directories

* `example.env` and `.env`: Used to set environment variables.
* `env.sh`: Must be sourced before running any docker commands, sets up environment variables and loads the `.env` file.
* `./cli`: Executable shell script which is used to run Composer, Drush and other tools. These are run inside a container. This is the only supported method of running these tools.
* `docker/`: Stores files for building and running the Docker Images and Containers, for example the Dockerfiles and Nginx configuration.
* `vendor/`: Where dependencies installed through Composer live. Mounted inside Docker containers as `/app/vendor`.
* `web/`: The Drupal HTTP web root, where you'll find `modules/`, `themes/`, etc. Mounted inside Docker containers as `/app/web`.
* `Makefile`: Tasks for building images and setting up the environment, executed by running `make`.
* `.gitignore`: Customise this as you see fit, it ships with some sensible defaults.
* `.editorconfig` and `.gitattributes`: The Drupal-shipped versions.

## Docker

[Refer to the README.md in the docker directory for more details and documentation.](docker/README.md)

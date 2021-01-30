# Docker PHP Drupal Template project

This is a template for starting a Drupal and PHP project/website running on Docker.

This template project is designed to provide a quick start approach to getting set up quickly with minimal effort required.

This template is not just for the development process, it is being architected in a way which supports a project moving through multiple environments: from dev, through test and eventually to the live production environment.

## First run and usage

Run `docker/build.sh` to build the Docker images, you will need to run this on:
* first time you setup a new system/environment
* make changes to any of the Dockerfiles and associated files
* rename the project directory, the name of this directory is used as part of the name of the built images and containers

Run `docker/compose-up.sh` to start the containers that run in Docker Compose (e.g. Nginx, PHP-FPM, etc).

It is encouraged and sometimes necessary to customise any and all of the Dockerfiles, Compose files and configuration shipped with this template.

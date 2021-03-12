# Docker PHP Drupal Template project

This is a template for starting a Drupal and PHP project/website running on Docker.

This template project is designed to provide a quick start approach to getting set up quickly with minimal effort required.

This template is not just for the development process, it is being architected in a way which supports a project moving through multiple environments: from dev, through test and eventually to the live production environment.

When you use this template, you're first instinct will be to scrap this README file, however it has some useful info, so consider building on it instead of replacing it :)

## First run and usage

Run `docker/build.sh` to build the Docker images, you will need to run this on:
* first time you setup a new system/environment
* make changes to any of the Dockerfiles and associated files
* rename the project directory, the name of this directory is used as part of the name of the built images and containers

Run `docker/compose-up.sh` to start the containers that run in Docker Compose (e.g. Nginx, PHP-FPM, etc).

It is encouraged and sometimes necessary to customise any and all of the Dockerfiles, Compose files and configuration shipped with this template.

## Key files and directories

* `docker/`: Stores files for building and running the Docker Images and Containers, e.g. docker-compose files, Dockerfiles, Nginx configuration, etc.
* `composer`: Executable shell script to run PHP Composer in a Container, any arguments/params passed to the script will be forwarded to Composer running inside the container. Treat it as a regular Composer PHAR, e.g. `./composer require ...` will work as expected, however note that (for now) Composer itself will not be aware of what directory you are in and will always run from the top level of the `app/` directory.
* `app/`: Where the PHP/Drupal app lives, where you'll find `composer.json`, `vender/` and `web/`. Mounted inside most containers, and Composer will use this as the app root when executing.
* `app/web/`: Assuming this is a standard Drupal or Symfony app, the Drupal HTTP web root, where you'll find `modules/`, `themes/`, etc.
* `.gitignore`: Customise this as you see fit, it ships with some sensible defaults.
* `.editorconfig` and `.gitattributes`: The Drupal-shipped versions.

## Docker

[Refer to the README.md in the docker directory for more details and documentation.](docker/README.md)

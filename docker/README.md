# Docker

A `drupal` Docker image is provided, based on the `php-fpm` image.

This image is also used when running:
* Composer 2
* Cron (uses Supercronic)
* Drush and any other similar tools.

## Architectural rational and methodology

Two of the main goals when architecting the containerised setup were that the setup should be reasonably secure but also simple enough to quickly understand what is going on.

With those decisions in mind, the choices detailed under the following sub-headings were made.

This section exists to provide clarify on why these choices were made, especially when sometimes there are multiple valid ways to accomplish something.

### Only one primary process per container (separation of concerns)

Following best practice and subscribing to the micro-service philosophy, each primary process runs in its own container.

For instance, this means that we have separate containers for related yet distinct processes, such as: PHP-FPM, Cron and Composer.

Keeping this separation means that these processes are properly isolated and filesystem permissions can be granted appropriately. For instance, the Composer image (./php-composer) is run with the user and group of the user running Composer commands, this is because it may need to write to the entire app directory; whereas the PHP-FPM processes (in the context of Drupal and under normal circumstances) would only need to write to the app/web/sites directory.

### Read-only file systems by default

In the interest of ensuring the integrity of the running container file systems, we mount them as read-only. This helps to mitigate the potential impact of a compromised container, and allows us to guarantee where our processes/apps are able to write files to.

When mounting the host's file system inside the container, for example the app directory, we only mount these with write permissions where it is necessary. For example, the app directory is mounted inside the Nginx container but Nginx should never need to write to it, so we mount it as read-only; Whereas PHP containers need some level of write access to the app directory, so we mount it with limited write permissions inside these containers.

The exception to this read-only rule is usually the /tmp directory. We set /tmp as a Temporary Filesystem (TempFS) inside each container, quite commonly running processes need to write files to /tmp. For example, Nginx writes some temporary files to /tmp in order to guarantee normal operations, such as its Process ID (PID). In theory if a container did become compromised and started writing suspicious files to /tmp, because this is a TempFS, we can simply restart the contianer and those files are gone.

All of these measures make it practically impossible for a malicious executable inside a container to start infecting system files of the containers, and ensures that any malicious process is very well isolated.

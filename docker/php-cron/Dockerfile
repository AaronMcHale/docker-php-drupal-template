# Start with our shared PHP image, built prior to this image being built.
# The image name will be in the format of `$project_name`_php, in `build.sh` we pass
# the project name in as a build argument using `PNAME` as the argument name.
ARG  PNAME
FROM "$PNAME"_php

# Add supercronic to this image, using the `hectormolinero/supercronic` image.
# Supercronic itself does not provide an image we can pull from, so we use
# `hectormolinero/supercronic` which does the work for us and Docker will
# provide the correct binary based on our platform requirements.
COPY --from=hectormolinero/supercronic /usr/bin/supercronic /usr/local/bin/

# Copy Crontab files into the image
COPY crontab /etc/

# Copy the specially written Drupal Cron PHP script into the iamge
COPY drupal-cron-run.php /
RUN chmod +x /drupal-cron-run.php

WORKDIR "/app"
USER www-data

# Use `supercronic` as the entry point and pass the crontab file to
# `supercronic`.
ENTRYPOINT [ "/usr/local/bin/supercronic" ]
CMD [ "/etc/crontab" ]

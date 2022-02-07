# Start with our shared PHP image, built prior to this image being built.
# The image name will be in the format of `$project_name`_php, in `build.sh` we pass
# the project name in as a build argument using `PNAME` as the argument name.
ARG  PNAME
FROM "$PNAME"_php

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

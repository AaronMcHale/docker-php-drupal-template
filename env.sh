# Sets up the environment for running docker compose.
#
# Before running `docker` commands, source this script by running:
# `. ./env.sh`
#
# Refer to the `README.md` for more information.

# Clear any previously stored values for known variables.
unset \
  ENVIRONMENT \
  DRUPAL_IMAGE_NAME \
  COMPOSE_FILE \
  ENV_USER_ID \
  ENV_GROUP_ID

# Get the name of parent directory and use it as the name for the image for
# the drupal and drupal-cli services in docker-compose.yml.
export DRUPAL_IMAGE_NAME="${PWD##*/}"

# Get the ID of the current user and user's group, used to run the containers.
export ENV_USER_ID="$(id -u)"
export ENV_GROUP_ID="$(id -g)"

if [ -f ".env" ]; then
  # Source the .env file but ignore comments and blank lines
  export $(grep '^[[:blank:]]*[^[:blank:]#]' .env | xargs)
else
  # Warn if .env file doesn't exist
  echo "WARNING: .env does not exist, .env must exist to run Traefik, copy local.env or prod.env."
fi

# Set initial value for COMPOSE_FILE so we can add to it next
export COMPOSE_FILE="docker-compose.yml"

# If we are not running on production, tell docker to run mailhog
if [ "$ENVIRONMENT" != "prod" ]; then
  export COMPOSE_FILE="$COMPOSE_FILE"":docker-compose.mailhog.yml"
fi

# If we have an environment-specific docker-compose file, tell Docker
# Compose to load that in addition to the base docker-compose file.
if [ -f "docker-compose.""$ENVIRONMENT"".yml" ]; then
  export COMPOSE_FILE="docker-compose.yml:docker-compose.""$ENVIRONMENT"".yml"
fi

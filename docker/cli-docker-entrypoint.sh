#!/usr/bin/env sh
#
# Lightweight entrypoint script for use with the drupal-cli services
# and the `cli` script. This script is designed to be run inside a
# container and called from the host, but it can be executed directly
# if needed.

# Exit this script if any exit with a non-zero state
set -e

# If the $CLI_CMD_ALIAS environment variable is available, then
# display the value of that variable to the user in help text,
# this should be the command the user ran on the host.
# If it is not set, use the name of this script `$0`.
if [ -z "$CLI_CMD_ALIAS" ]; then
  entry_cmd_alias="$0"
else
  entry_cmd_alias="$CLI_CMD_ALIAS"
fi

# Help text to show to the user when they don't provide any command
# or enter a command that isn't recognised. When adding new commands
# be sure to also add an entry in the help text.
print_help() {
  echo "Entrypoint script for running common Drupal CLI utilities and commands."
  echo
  echo "Usage: ""$entry_cmd_alias"" [ARGS] COMMAND ..."
  echo
  echo "Available arguments:"
  echo "  --with-ssh-agent  Start an SSH agent in the container, useful for Drush sync commands"
  echo
  echo "Available commands:"
  echo "  composer"
  echo "  drupal"
  echo "  drush"
  echo "  shell (sh)  Interactive terminal or run commands."
  # exit the script after printing the help text, as we don't need to
  # do anyting else after the help text is shown.
  exit 0
}

if [ $# -eq 0 ]; then
  # No command passed, show help
  print_help
fi

# If the flag is provided, start an SSH agent inside the container.
# Useful when running commands like drush sql:sync where it can make multiple
# remote connections over SSH.
if [ "$1" == "--with-ssh-agent" ]; then
  echo "Starting SSH agent, you may be prompted to unlock your private key..."
  eval $(/usr/bin/ssh-agent)
  /usr/bin/ssh-add
  shift
fi

# Save `$1` as `$opt`, then use the `shift` utility to remove `$1` as it
# is no longer need it, `$2` then becomes `$1` and so on. In other words
# this shifts forward all of the positional arguments passed to this script.
# For example if the user entered `composer update`, the first argument,
# `composer` is dropped. This means that `$@` would then simply be `update`.
# We can then safely pass `$@` to `/user/bin/composer` as if the user had
# called it directly.
opt=$1
shift

# This is the actual logic which sets the command which will be run
# based on the user's selection. We check on `$1``, which is the
# first argument passed to this script, for instance:
# `./cli-docker-entrypoint.sh composer` in this case "composer" is
# the command to check for.
# When adding new commands, add a new case, and set the `cmd`
# variable to the path of the actual executable to run.
case "$opt" in
  "composer")
    cmd="/usr/local/bin/composer" ;;
  "drupal")
    # Run the `drupal` utility which comes with Core.
    if [ ! -f "/app/web/core/scripts/drupal" ]; then
      echo "Drupal Core does not appear to be installed:"
      echo "Error: /app/web/core/scripts/drupal does not exist"
      exit 1
    fi
    cmd="php /app/web/core/scripts/drupal" ;;
  "drush")
    # Test to make sure Drush has actually been installed in the project
    # before trying to run it, Drush is installed as part of the project
    # using Composer, so we can't assume it exists.
    if [ ! -x "/app/vendor/bin/drush" ]; then
      echo "Could not find Drush, has it been installed? Install Drush with:"
      echo "$entry_cmd_alias"" composer require drush/drush"
      echo "Error: /app/vendor/bin/brush is not executable"
      exit 1
    fi
    cmd="/app/vendor/bin/drush" ;;
  "sh"|"shell")
    if [ "$1" = "--bash" ]; then
      cmd="/bin/bash"
      # Remove "--bash" from the positional arguments so it is not passed to /bin/bash
      shift
    elif [ "$1" = "--help" ]; then
      echo "Start a shell in a new container, defaults to /bin/sh in interactive mode."
      echo
      echo "Usage: ""$entry_cmd_alias"" shell [ARGS] ..."
      echo
      echo "Arguments:"
      echo "  --bash  Use /bin/bash instead of /bin/sh as the shell"
      echo "  --help  Displays this message"
      echo
      echo "All further arguments are passed to the shell on startup."
      echo
      echo "To run a command using the shell, use -c followed by the command."
      exit 0
    else
      cmd="/bin/sh"
    fi
    ;;
  *)
    # If the command entered by the user was not known, then print help.
    print_help ;;
esac

# We use tini to run the actual command with all of the arguments that the
# user provided. Tini is a useful utility for running inside containers
# as it takes care of managing signals, among other things. For more
# info see: https://github.com/krallin/tini
# Use `set` to override `$@` with the command below, which is then passed
# into `exec`.
set -- /sbin/tini -- $cmd $@

# Use `exec` to run the final command, which as built using `set` along
# with all of its arguments and parameters.
# `exec` runs the command but replaces the current shell with the command.
# This essentially ensures that tini is the first process running in the
# container, tini will then spawn the sub-process for running the actual
# command.
exec $@

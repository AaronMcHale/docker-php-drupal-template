<?php

// phpcs:ignoreFile

/**
 * @file
 * Drupal site-specific configuration file.
 *
 * This file is copied to web/sites/default/settings.php by Composer using the
 * Drupal Scaffold plugin. It is not replaced, only copied if it does not exist.
 * Drupal may make changes to this file stored in web/sites/default, for instance,
 * by setting the hash_salt on install.
 *
 * The database connection information and config sync directory are set in the
 * docker-compose.yml file as environment variables. Drupal will use those rather
 * than looking in this file.
 */

/**
 * Salt for one-time login links, cancel links, form tokens, etc.
 *
 * This variable will be set to a random value by the installer. All one-time
 * login links will be invalidated if the value is changed. Note that if your
 * site is deployed on a cluster of web servers, you must ensure that this
 * variable has the same value on each server.
 *
 * For enhanced security, you may set this variable to the contents of a file
 * outside your document root, and vary the value across environments (like
 * production and development); you should also ensure that this file is not
 * stored with backups of your database.
 *
 * Example:
 * @code
 *   $settings['hash_salt'] = file_get_contents('/home/example/salt.txt');
 * @endcode
 */
$settings['hash_salt'] = '';

/**
 * Settings which may vary depending on the environment are stored in the
 * from-env.settings.php file.
 */
include "$app_root/$site_path/settings.from-env.php";

/**
 * Settings added automatically by Drupal may appear below this comment.
 */

#!/usr/bin/env php
<?php

/**
 * @file
 * A executable PHP script for running Drupal's Cron from the
 * command line.
 *
 * Eventually there may be a "Cron Command" as part of the Core
 * Drupal Console Command "core/scripts/drupal", if/when a Cron
 * Command is included this script can be removed.
 * @see https://www.drupal.org/project/ideas/issues/3089277
 */

// Open streams to Standard Out and Standard Error
$stdout = fopen('php://stdout', 'w');
$stderr = fopen('php://stderr', 'w');

fwrite($stdout, "Running Drupal Cron script.\n");

use Drupal\Core\Database\ConnectionNotDefinedException;
use Drupal\Core\DrupalKernel;
use Symfony\Component\HttpFoundation\Request;

// @todo figure out path from environment maybe?
$app_root = '/app/web';

if (!is_dir($app_root)) {
  fwrite($stderr, "Unable to run Drupal Cron: Expected path $app_root which does not exist in the Cron Container, aborting.\n");
  exit(1);
}

// chdir to the app_root directory, ensures Drupal root-relative
// paths can be resolved (otherwise SQLite connections fail).
chdir($app_root);

$autoload_filename = 'autoload.php';

if (!file_exists($autoload_filename)) {
  fwrite($stderr, "Unable to run Drupal Cron: Could not find $autoload_filename in $app_root, aborting.\n");
  exit(1);
}

$autoloader = require_once $autoload_filename;

// Initialise a Request and Kernel
$request = Request::createFromGlobals();
$kernel = DrupalKernel::createFromRequest($request, $autoloader, 'prod');
try {
  $kernel->boot();
}
catch (ConnectionNotDefinedException $ex) {
  fwrite($stderr, "Unable to run Drupal Cron: Could not initialise a database connection, Drupal is probably not installed (\Drupal\Core\DrupalKernel::boot() threw exception \Drupal\Core\Database\ConnectionNotDefinedException).\n");
  exit(1);
}

  /** @var \Drupal\Core\CronInterface $cron */
$cron = $kernel->getContainer()->get('cron');

// Run Cron, essentially mimicking what the "/cron" URL does
// @see \Drupal\system\CronController::run
if ($cron->run()) {
  fwrite($stdout, "Drupal Cron run completed.\n");
  exit(0);
}
else {
  fwrite($stderr, "Unable to run Drupal Cron: Failed while executing \Drupal\Core\CronInterface::run().\n");
  exit(1);
}

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

use Drupal\Core\DrupalKernel;
use Symfony\Component\HttpFoundation\Request;

// @todo figure out path from environment maybe?
$app_root = '/var/www/app/web';

// chdir to the app_root directory, ensures Drupal root-relative
// paths can be resolved (otherwise SQLite connections fail).
chdir($app_root);

$autoloader = require_once 'autoload.php';

// Initialise a Request and Kernel
$request = Request::createFromGlobals();
$kernel = DrupalKernel::createFromRequest($request, $autoloader, 'prod');
$kernel->boot();

  /** @var \Drupal\Core\CronInterface $cron */
$cron = $kernel->getContainer()->get('cron');

// Run Cron, essentially mimicking what the "/cron" URL does
// @see \Drupal\system\CronController::run
$cron->run();

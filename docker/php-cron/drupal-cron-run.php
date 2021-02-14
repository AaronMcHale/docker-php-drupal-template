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
$autoloader = require_once '/var/www/app/web/autoload.php';

// Initialise a Request and Kernel
$request = Request::createFromGlobals();
$kernel = DrupalKernel::createFromRequest($request, $autoloader, 'prod', '/var/www/app');
$kernel->boot();

  /** @var \Drupal\Core\CronInterface $cron */
$cron = $kernel->getContainer()->get('cron');

// Run Cron, essentially mimicking what the "/cron" URL does
// @see \Drupal\system\CronController::run
$cron->run();

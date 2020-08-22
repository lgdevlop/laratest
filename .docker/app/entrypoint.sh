#!/usr/bin/env bash

composer install
php artisan config:clear
php artisan optimize:clear
php artisan key:generate
php artisan config:cache
php artisan migrate
php-fpm

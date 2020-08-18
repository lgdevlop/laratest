#!/usr/bin/env bash

echo $DB_HOST_NAME

health=$(curl -v "http://$DB_HOST_NAME:3306" 2>&1 | grep -o "Connected to")

while [ -z "$health" ]; do
  sleep 3s
  echo $DB_HOST_NAME
  health=$(curl -v "http://$DB_HOST_NAME:3306" 2>&1 | grep -o "Connected to")
done

composer install
php artisan config:clear
php artisan optimize:clear
php artisan key:generate
php artisan config:cache
php artisan migrate
php-fpm

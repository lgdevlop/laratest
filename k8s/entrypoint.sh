#!/usr/bin/env bash

CDB="CREATE DATABASE IF NOT EXISTS laravel;"
DB_HOST=$(cat .env | grep DB_HOST | cut -d "=" -f2)

export MAGENTABG='\033[45m'
export WHITE='\033[97m'
export RESET='\033[0m'

echo ""
echo -e "${MAGENTABG}${WHITE} Tentando conectar em: http://${DB_HOST}:3306 ${RESET}"
health=$(curl -v "http://$DB_HOST:3306" 2>&1 | grep -o "Connected to")
retries=0
max_retries=4

while [ -z "$health" ]; do
  if [[ "$retries" = "$max_retries" ]]; then
    echo ""
    exit
  fi
  sleep 4s
  echo -e "${MAGENTABG}${WHITE} Tentando conectar em: http://${DB_HOST}:3306 ${RESET}"
  health=$(curl -v "http://$DB_HOST:3306" 2>&1 | grep -o "Connected to")
  ((retries=$retries+1))
done

mysql -uroot -h$DB_HOST -p$DB_PASSWORD -e "$CDB"

# php artisan config:clear
# php artisan optimize:clear
# php artisan key:generate
php artisan config:cache
php artisan migrate
php-fpm

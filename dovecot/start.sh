#!/bin/bash

SHOULD_EXIT_EARLY=false

# if [ ! -d "/srv/config" ]; then
#     echo "/srv/config is not mounted"
#     SHOULD_EXIT_EARLY=true
# fi

function var_not_set {
    echo "Environment variable $1 is not set"
    SHOULD_EXIT_EARLY=true
}

########
##
## Variables
##

if [ -z $HOSTNAME ]; then
    HOSTNAME="$(hostname -f)"
fi

if [ -z $DB_HOST ]; then
    var_not_set "DB_HOST"
fi

if [ -z $DB_USER ]; then
    var_not_set "DB_USER"
fi

# if [ -z $DB_PASSWORD ]; then
#     var_not_set "DB_PASSWORD"
# fi

if [ -z $DB_NAME ]; then
    var_not_set "DB_NAME"
fi

########
##
## Test if we should return early
##

if [ $SHOULD_EXIT_EARLY = true ]; then
    exit 1
fi

########
##
## Preparation
##

find /etc/dovecot/ -type f \
    -name 'dovecot-sql.conf' \
    -exec sed -i "s/host=127.0.0.1 dbname=mum_database user=mum_dovecot_user password=mum_dovecot_password/host=${DB_HOST} dbname=${DB_NAME} user=${DB_USER} password=${DB_PASSWORD}/g" {} \;

########
##
## Start
##

echo "Starting Dovecot..."
dovecot -F
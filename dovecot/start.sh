#!/bin/bash

if [ ! -d "/srv/config" ]; then
    echo "/srv/config is not mounted"
    exit 1
fi

function var_not_set {
    echo "Environment variable $1 is not set"
    exit 1
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

if [ -z $DB_PASSWORD ]; then
    var_not_set "DB_PASSWORD"
fi

if [ -z $DB_NAME ]; then
    var_not_set "DB_NAME"
fi

########
##
## Preparation
##

cp /srv/config/dovecot{,-sql}.conf /etc/dovecot/
find /srv/sql/ -type f -name 'dovecot-sql.conf' -exec sed -i "s/host=127.0.0.1 dbname=mum_database user=mum_dovecot_user password=mum_dovecot_password/host=${HOSTNAME} dbname=${DB_NAME} user=${DB_USER} password=${DB_PASSWORD}/g" {} \;

########
##
## Dovecot Configuration
##



########
##
## Start
##

postfix start &
touch /var/log/mail.log
tail -f /var/log/mail.log
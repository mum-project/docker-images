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

if [ -z $DB_USER_POSTFIX ]; then
    DB_USER_POSTFIX="mum_postfix"
fi

if [ -z $DB_PASSWORD_POSTFIX ]; then
    var_not_set "DB_PASSWORD_POSTFIX"
fi

if [ -z $DB_NAME ]; then
    var_not_set "DB_NAME"
fi

if [ -z $DB_HOST ]; then
    var_not_set "DB_HOST"
fi

########
##
## Preparation
##

cp /srv/config/main.cf /etc/postfix/
cp /srv/config/master.cf /etc/postfix/
find /srv/sql/ -type f -name '*.cf' -exec sed -i "s/mum_postfix_user/${DB_USER_POSTFIX}/g" {} \;
find /srv/sql/ -type f -name '*.cf' -exec sed -i "s/mum_postfix_password/${DB_PASSWORD_POSTFIX}/g" {} \;
find /srv/sql/ -type f -name '*.cf' -exec sed -i "s/mum_postfix_password/${DB_PASSWORD_POSTFIX}/g" {} \;
find /srv/sql/ -type f -name '*.cf' -exec sed -i "s/mum_database/${DB_NAME}/g" {} \;
find /srv/sql/ -type f -name '*.cf' -exec sed -i "s/127.0.0.1/${DB_HOST}/g" {} \;

########
##
## Postfix Configuration
##

postconf -e "myhostname = $HOSTNAME"

########
##
## Start
##

postfix start &
touch /var/log/mail.log
tail -f /var/log/mail.log
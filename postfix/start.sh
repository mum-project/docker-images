#!/bin/bash

################################################################################
## Variables
##
if [ -z $HOSTNAME ]; then
    HOSTNAME="$(hostname -f)"
fi

################################################################################
## Postfix Configuration
##
postconf -e "myhostname = $HOSTNAME"

################################################################################
## Start
##

postfix start &
touch /var/log/mail.log
tail -f /var/log/mail.log
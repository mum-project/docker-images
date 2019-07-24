FROM alpine

# Install pre-requirements
RUN apk update
RUN apk add --no-cache ca-certificates rsyslog supervisor
RUN update-ca-certificates


RUN apk add --no-cache postfix postfix-mysql

# For development
RUN apk add busybox-extras

RUN mkdir /var/spool/postfix/etc && echo "smtp		25/tcp		mail		# Simple Mail Transfer" > /var/spool/postfix/etc/services

COPY config/main.cf /etc/postfix/
COPY config/master.cf /etc/postfix/
COPY docker/sql /srv/sql
COPY docker/supervisord.conf /etc/
COPY docker/rsyslog.conf /etc/
COPY start.sh /srv/start.sh
RUN chmod +x /srv/start.sh

#   25: SMTP (Server2Server)
#  465: SMTP (SSL, deprecated)
#  587: SMTP (StartTLS)
EXPOSE 25 465 587

ENTRYPOINT [ "sh" , "/srv/start.sh" ]
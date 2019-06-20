FROM alpine

# Install pre-requirements
RUN apk update
RUN apk add --no-cache ca-certificates inetutils-syslogd runit
RUN update-ca-certificates


RUN apk add --no-cache postfix postfix-mysql

# For development
RUN apk add busybox-extras

COPY docker/sql /srv/sql
COPY start.sh /srv/start.sh
RUN chmod +x /srv/start.sh

#   25: SMTP (Server2Server)
#  465: SMTP (SSL, deprecated)
#  587: SMTP (StartTLS)
EXPOSE 25 465 587

ENTRYPOINT [ "sh" , "/srv/start.sh" ]
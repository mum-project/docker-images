FROM alpine

RUN apk update && apk add dovecot-core dovecot-imapd

# For development
RUN apk add busybox-extras

COPY docker/sql /srv/sql
COPY start.sh /srv/start.sh
RUN chmod +x /srv/start.sh

ENTRYPOINT [ "sh" , "/srv/start.sh" ]
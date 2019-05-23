FROM alpine

RUN apk update && apk add postfix postfix-mysql

# For development
RUN apk add busybox-extras

COPY config/main.cf /etc/postfix/main.cf
COPY start.sh /srv/start.sh
RUN chmod +x /srv/start.sh

ENTRYPOINT [ "sh" , "/srv/start.sh" ]
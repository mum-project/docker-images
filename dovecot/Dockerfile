FROM alpine

# Update base system
RUN apk update
RUN apk add --no-cache ca-certificates
RUN update-ca-certificates

# Disable Dovecot TLS during installation to prevent key from being pregenerated
RUN mkdir -p /etc/dovecot && echo "ssl = no" > /etc/dovecot/local.conf

# Install all alpine dovecot packages (except documentation and development files)
RUN apk add --no-cache \
	dovecot \
	dovecot-pigeonhole-plugin \
	dovecot-lmtpd \
	dovecot-mysql

# For development
RUN apk add busybox-extras

COPY config/dovecot.conf /etc/dovecot/
COPY docker/dovecot-sql.conf /etc/dovecot/dovecot-sql.conf
COPY start.sh /srv/start.sh
RUN chmod +x /srv/start.sh

ENV USER=vmail
ENV UID=5000
ENV GID=5000

RUN addgroup --gid "$GID" "$USER" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

VOLUME /srv/mail

#    24: LMTP
#   110: POP3 (StartTLS)
#   143: IMAP4 (StartTLS)
#   993: IMAP (SSL, deprecated)
#   995: POP3 (SSL, deprecated)
#  4190: ManageSieve (StartTLS)
# 12345: SASL Auth (for Postfix)
EXPOSE 24 110 143 993 995 4190 12345

ENTRYPOINT [ "sh" , "/srv/start.sh" ]
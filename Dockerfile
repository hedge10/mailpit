FROM alpine:3

WORKDIR /

COPY openssl.conf entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

RUN apk add --no-cache \
    curl \
    openssl

RUN mkdir /certs \
    && openssl req -x509 -newkey rsa:4096 -nodes -keyout certs/privkey.pem -out certs/mailpit.pem -sha256 -days 365 -config openssl.conf \
    && mv certs/mailpit.pem /usr/local/share/ca-certificates/mailpit.crt \
    && update-ca-certificates

COPY --from=axllent/mailpit /mailpit /usr/local/bin/mailpit
RUN chmod +x /usr/local/bin/mailpit

ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
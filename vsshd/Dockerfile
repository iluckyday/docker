FROM alpine:edge

RUN apk add --no-cache openssh-server

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]

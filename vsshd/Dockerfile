FROM debian:sid-slim

RUN apt-get update && \
    apt-get install -y openssh-server wget unzip && \
    apt-get clean

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]

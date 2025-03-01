# Based off https://github.com/ariya/phantomjs/blob/2.1.1/deploy/docker-build.sh
FROM debian:bookworm AS builder

ENV QT_QPA_PLATFORM=offscreen

ADD . /tmp

WORKDIR /tmp

RUN chmod +x build.sh

RUN ./build.sh

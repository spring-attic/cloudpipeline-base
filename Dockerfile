FROM openjdk:8-jdk-alpine

MAINTAINER Toshiaki Maki <tmaki@pivotal.io>

RUN apk upgrade
RUN apk add --update \
    bash \
    git \
    tar \
    openssh-client \
    openssh \
    zip \
    curl

FROM openjdk:8-jdk-alpine

MAINTAINER Toshiaki Maki <tmaki@pivotal.io>
MAINTAINER Marcin Grzejszczak <mgrzejszczak@pivotal.io>

RUN apk upgrade
RUN apk add --update \
    bash \
    git \
    tar \
    openssh-client \
    openssh \
    zip \
    curl \
    ruby \
    software-properties-common \
    build-essential \
    wget \
    libssl-dev \
    libxml2-dev \
    libsqlite3-dev \
    libxslt1-dev \
    libpq-dev \
    libmysqlclient-dev \
    bsdtar \
    unzip \
    python \
    gem \
    xvfb \
    x11-xkb-utils \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-scalable \
    xfonts-cyrillic \
    x11-apps \
    libqtwebkit-dev \
    qt4-qmake

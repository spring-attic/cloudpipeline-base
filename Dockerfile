FROM ubuntu:14.04

MAINTAINER Toshiaki Maki <tmaki@pivotal.io>
MAINTAINER Marcin Grzejszczak <mgrzejszczak@pivotal.io>

ENV RUBY_VERSION 2.3.1
ENV TERM dumb

RUN apt-get -y update
RUN apt-get -y install software-properties-common

RUN apt-get -y update
RUN apt-get -y install \
    bash \
    git \
    tar \
    openssh-client \
    zip \
    curl \
    ruby \
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

RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get -y install oracle-java8-installer
RUN apt-get -y install apt-transport-https
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
RUN echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN apt-get -y update
RUN apt-get -y install cf-cli

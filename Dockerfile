FROM ubuntu:19.04

MAINTAINER Toshiaki Maki <tmaki@pivotal.io>
MAINTAINER Marcin Grzejszczak <mgrzejszczak@pivotal.io>

ARG SDKMAN_JAVA_INSTALLATION=8.0.222-zulu
ARG UBUNTU_VERSION=19.04

ENV RUBY_VERSION 2.3.1
ENV TERM dumb
ENV ENTRYKIT_VERSION=0.4.0
ENV DEBIAN_FRONTEND noninteractive

# Create a user that we can use besides root when building app
RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -m -g appuser appuser

RUN apt-get -y update
RUN apt-get -y install \
    sudo \
    software-properties-common \
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
    qt4-qmake \
    jq \
    apt-transport-https

RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list

RUN apt-get update && \
  apt-get dist-upgrade -y

## Remove any existing JDKs
RUN apt-get --purge remove openjdk*

# Install sdkman and java
RUN curl -s https://get.sdkman.io/ | bash
COPY sdkman.config /.sdkman/etc/config
COPY sdkman/ /usr/local/bin/
RUN /bin/bash -c "chmod +x /usr/local/bin/sdkman-exec.sh && chmod +x /usr/local/bin/sdkman-wrapper.sh && chmod +x /root/.sdkman/bin/sdkman-init.sh"
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh"
RUN sdkman-wrapper.sh install java "${SDKMAN_JAVA_INSTALLATION}"
ENV JAVA_HOME /root/.sdkman/candidates/java/current/
ENV PATH "${PATH}:${JAVA_HOME}/bin"

RUN apt-get -y update
RUN apt-get -y install \
    cf-cli

# Install entrykit
RUN curl -L https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz | tar zx && \
    chmod +x entrykit && \
    mv entrykit /bin/entrykit && \
    entrykit --symlink

# Making docker in docker possible
#USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install apt-transport-https ca-certificates && \
    echo "deb https://apt.dockerproject.org/repo debian-jessie main" | tee /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install --assume-yes docker-engine && \
    echo 'Defaults  env_keep += "HOME"' >> /etc/sudoers

# Include useful functions to start/stop docker daemon in garden-runc containers in Concourse CI.
# Example: source /docker-lib.sh && start_docker
COPY docker-lib.sh /docker-lib.sh

# DOTNET
RUN wget -q https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb
RUN apt-get -y install apt-transport-https
RUN apt-get update
RUN apt-get -y install dotnet-sdk-2.1

# NODEJS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# PHP
ENV LANG=C.UTF-8
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get -y update && apt-get -y install php7.2
RUN apt-get -y install php-pear php7.2-curl php7.2-dev php7.2-gd php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xml

ENTRYPOINT [ \
	"switch", \
		"shell=/bin/sh", "--", \
	"codep", \
		"/bin/docker daemon" \
]

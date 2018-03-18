FROM ubuntu:16.04

MAINTAINER Toshiaki Maki <tmaki@pivotal.io>
MAINTAINER Marcin Grzejszczak <mgrzejszczak@pivotal.io>

ENV RUBY_VERSION 2.3.1
ENV TERM dumb
ENV ENTRYKIT_VERSION=0.4.0
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

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
    qt4-qmake \
    jq \
    apt-transport-https

RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list

RUN apt-get update && \
  apt-get dist-upgrade -y

## Remove any existing JDKs
RUN apt-get --purge remove openjdk*

RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

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

ENTRYPOINT [ \
	"switch", \
		"shell=/bin/sh", "--", \
	"codep", \
		"/bin/docker daemon" \
]

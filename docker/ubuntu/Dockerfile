FROM ubuntu:18.04
#MAINTAINER Getty Images "https://github.com/gettyimages"



RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      locales \
      iputils-ping \
      inetutils-telnet \
      net-tools \
      curl \
      python3 \
      python3-setuptools \
      python3-pip \
      ca-certificates \
      wget \
      dirmngr \
      gnupg \
    && dpkg-reconfigure -f noninteractive locales \
    && locale-gen en_US.UTF-8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    # && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && for server in $(shuf -e ha.pool.sks-keyservers.net \
                            hkp://p80.pool.sks-keyservers.net:80 \
                            keyserver.ubuntu.com \
                            hkp://keyserver.ubuntu.com:80 \
                            pgp.mit.edu) ; do \
        gpg --keyserver "$server" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || : ; \
    done \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

# Users with other locales should set this in their derivative image
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    PYTHONHASHSEED=0 \
    PYTHONIOENCODING=UTF-8 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    JAVA_MAJOR_VERSION=8 \ 
    JAVA_UPDATE_VERSION=201 \
    JAVA_BUILD_NUMBER=09

# JAVA
ENV JAVA_HOME=/opt/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION} \
    PATH=/opt/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}/bin:$PATH

RUN mkdir $JAVA_HOME \
    && echo "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/42970487e3af4f5aa5bca3f542482c60/jdk-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz" \
    && curl -fSL --retry 3 --insecure --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/42970487e3af4f5aa5bca3f542482c60/jdk-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz" \
  | tar --strip-components=1 -zxf - -C $JAVA_HOME \
  && ln -s $JAVA_HOME /usr/java \
  && rm -rf $JAVA_HOME/man /tmp/* /var/tmp/*

CMD ["/bin/bash"]
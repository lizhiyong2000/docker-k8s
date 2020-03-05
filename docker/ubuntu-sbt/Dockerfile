FROM lizhiyong2000/ubuntu:18.04

#MAINTAINER Zhiyong Li <lizhiyong2000@gmail.com>
ENV SBT_VERSION=0.13.17 \
    SBT_HOME=/opt/sbt \
    PATH=${PATH}:/opt/sbt/bin


RUN apt-get update \
 && apt-get install --no-install-recommends -y unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Installing Scala from source
RUN mkdir -p ${SBT_HOME} \
    && curl -fSL  https://piccolo.link/sbt-${SBT_VERSION}.tgz \
    # && curl -fSL  http://192.168.3.2:8080/sample/sbt-$SBT_VERSION.tgz \
    | tar --strip-components=1 -zxf - -C $SBT_HOME \
    && echo "Show SBT version" \
    && sbt about -v
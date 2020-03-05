FROM lizhiyong2000/ubuntu:18.04
#MAINTAINER lizhiyong2000@gmail.com

# AMBARI

ENV MAVEN_VERSION=3.6.0 \
    MAVEN_HOME=/opt/maven \
    AMBARI_VERSION=2.7.3 \
    AMBARI_VERSION_BUILD=2.7.3.0.0 \
    AMBARI_HOME=/opt/ambari \
    AMBARI_SRC_HOME=/opt/ambari_src \
    PATH=$PATH:/opt/maven/bin


RUN mkdir $MAVEN_HOME && curl -fSL --retry 3 \
  "http://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" \
  | tar --strip-components=1 -zxf - -C $MAVEN_HOME \
    &&  mkdir $AMBARI_SRC_HOME && curl -fSL --retry 3 \
  "http://www.apache.org/dist/ambari/ambari-$AMBARI_VERSION/apache-ambari-$AMBARI_VERSION-src.tar.gz" \
  | tar --strip-components=1 -zxf - -C $AMBARI_SRC_HOME \
  && rm -rf /tmp/* /var/tmp/* 
 # && chown -R root:root $AMBARI_HOME


RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      python2.7 \
      libpython2.7-dev \
      python2.7-setuptools \
      python-pip \
      git \
      g++ \
    && rm  /usr/bin/python && ln -s /usr/bin/python2.7 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN cd $AMBARI_SRC_HOME \
&& mvn versions:set -DnewVersion=$AMBARI_VERSION_BUILD \
&& cd ambari-metrics \
&& mvn versions:set -DnewVersion=$AMBARI_VERSION_BUILD \
&& cd .. \
&& mvn -B clean install jdeb:jdeb -DnewVersion=2.7.3.0.0 -DbuildNumber=4295bb16c439cbc8fb0e7362f19768dde1477868 -DskipTests -Dpython.ver="python >= 2.6" 

RUN mkdir $AMBARI_HOME && cd $AMBARI_HOME && cp $AMBARI_SRC_HOME/ambari-server/target/*.deb $AMBARI_HOME && cp $AMBARI_SRC_HOME/ambari-agent/target/*.deb $AMBARI_HOME  \
    && rm -rf $AMBARI_SRC_HOME && rm -rf /root/.m2 && rm -rf /tmp/* /var/tmp/* 

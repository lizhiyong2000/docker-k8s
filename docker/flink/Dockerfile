FROM lizhiyong2000/ubuntu:18.04

ARG HADOOP_VERSION=28
ARG SCALA_BINARY_VERSION=2.11

ENV FLINK_VERSION=1.5.1 \
    SBT_VERSION=1.1.6 \
    SCALA_VERSION=2.11.8 \
    SCALA_PKG=scala-2.11.8 \
    SCALA_HOME=/opt/scala \
    SBT_HOME=/opt/sbt \
    FLINK_HOME=/opt/flink \ 
    PATH=$PATH:/opt/flink/bin:/opt/scala/bin:/opt/sbt/bin

# Installing Scala from source
RUN mkdir -p ${SCALA_HOME} && mkdir -p ${SBT_HOME} \
    # && curl -fSL http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.tgz \
    && curl -fSL http://192.168.3.2:8080/sample/scala-$SCALA_VERSION.tgz \
    | tar --strip-components=1 -zxf - -C $SCALA_HOME \
    # && curl -fSL  https://piccolo.link/sbt-$SBT_VERSION.tgz \
    && curl -fSL  http://192.168.3.2:8080/sample/sbt-$SBT_VERSION.tgz \
    | tar --strip-components=1 -zxf - -C $SBT_HOME \
    && echo "Show SBT version" 
     # && \ sbt about -v


RUN mkdir -p ${FLINK_HOME} && \
    curl -fSL --retry 3 \
    "http://192.168.3.2:8080/sample/flink-${FLINK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala_${SCALA_BINARY_VERSION}.tgz" \
    # "http://archive.apache.org/dist/flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala_${SCALA_BINARY_VERSION}.tgz" \
    | tar --strip-components=1 -zxf - -C $FLINK_HOME \
    && rm -rf /tmp/* /var/tmp/* && \
    sed -i -e "s/echo \$mypid >> \$pid/echo \$mypid >> \$pid \&\& wait/g" ${FLINK_HOME}/bin/flink-daemon.sh && \
    sed -i -e "s/ > \"\$out\" 2>&1 < \/dev\/null//g" ${FLINK_HOME}/bin/flink-daemon.sh && \
    echo Installed Flink ${FLINK_VERSION} to ${FLINK_HOME}

ADD docker-entrypoint.sh ${FLINK_HOME}/bin/
# Additional output to console, allows gettings logs with 'docker-compose logs'
ADD log4j.properties ${FLINK_HOME}/conf/

WORKDIR $FLINK_HOME

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["sh", "-c"]

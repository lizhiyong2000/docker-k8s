FROM lizhiyong2000/ubuntu:18.04

#MAINTAINER Zhiyong Li <lizhiyong2000@gmail.com>

ARG kafka_version=1.1.0
ARG scala_version=2.12
ARG kafka_home=/opt/kafka



ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_USER=kafka \
    KAFKA_HOME=$kafka_home \
    KAFKA_LOG_DIR=$kafka_home/logs \
	PATH=${PATH}:${kafka_home}/bin

WORKDIR $KAFKA_HOME


RUN curl -fSL "http://www.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" | \
    tar --strip-components=1 -zxf - -C $KAFKA_HOME  \
 && apt-get update \
 && apt-get install --no-install-recommends -y jq \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir $KAFKA_LOG_DIR \
 && rm -rf /tmp/* /var/tmp/  \
 && groupadd --gid 1000 $KAFKA_USER \
 && useradd --uid 1000 --gid 1000 --home-dir $KAFKA_HOME --no-create-home $KAFKA_USER \
 && chown -R $KAFKA_USER:$KAFKA_USER $KAFKA_HOME



COPY --chown=1000:0 script/start-kafka.sh script/broker-list.sh script/create-topics.sh ${KAFKA_HOME}/bin/

RUN chown -R kafka:0 . && \
    chmod -R g=u $KAFKA_HOME && \
    chmod g=u /etc/passwd && \
    chmod 0775 $KAFKA_HOME/bin/*.sh


USER $KAFKA_USER

EXPOSE $KAFKA_PORT

VOLUME ["$KAFKA_LOG_DIR"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)



CMD ["start-kafka.sh"]

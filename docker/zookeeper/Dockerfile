FROM lizhiyong2000/ubuntu:18.04

#MAINTAINER Zhiyong Li <lizhiyong2000@gmail.com>

ENV ZOO_VERSION=3.4.12 \
    ZOO_HOME=/opt/zookeeper \
    ZOO_LOG_DIR=/var/log/zookeeper \
    ZOO_USER=zookeeper \
    ZOO_PORT=2181 \
    ZOO_TICK_TIME=2000 \
    ZOO_INIT_LIMIT=5 \
    ZOO_SYNC_LIMIT=2 \
    ZOO_MAX_CLIENT_CNXNS=60 

ENV ZOO_CONF_DIR=${ZOO_HOME}/conf \
    ZOO_DATA_DIR=${ZOO_HOME}/data \
    ZOO_DATA_LOG_DIR=${ZOO_HOME}/datalog \
    PATH=$PATH:${ZOO_HOME}/bin

#Download Zookeeper
RUN curl -o zookeeper-${ZOO_VERSION}.tar.gz http://mirror.vorboss.net/apache/zookeeper/zookeeper-${ZOO_VERSION}/zookeeper-${ZOO_VERSION}.tar.gz \ 
    && tar -xzf zookeeper-${ZOO_VERSION}.tar.gz -C /opt \
    && mv /opt/zookeeper-${ZOO_VERSION} ${ZOO_HOME} \
    && rm zookeeper-${ZOO_VERSION}.tar.gz \
    && mkdir $ZOO_DATA_DIR && mkdir $ZOO_DATA_LOG_DIR \
    && sed -i -r 's|#(log4j.appender.ROLLINGFILE.MaxBackupIndex.*)|\1|g' $ZOO_HOME/conf/log4j.properties  \
    && groupadd --gid 1001 $ZOO_USER \
    && useradd --uid 1001 --gid 1001 --home-dir $ZOO_HOME --no-create-home $ZOO_USER \
    && chown -R $ZOO_USER:$ZOO_USER $ZOO_HOME \
    && mkdir $ZOO_LOG_DIR \
    && chown -R $ZOO_USER:$ZOO_USER $ZOO_HOME


RUN apt-get update \
 && apt-get install --no-install-recommends -y netcat \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --chown=zookeeper:zookeeper docker-entrypoint.sh zooOK.sh $ZOO_HOME/bin/

RUN chmod 755 $ZOO_HOME/bin/docker-entrypoint.sh $ZOO_HOME/bin/zooOK.sh


VOLUME ["$ZOO_DATA_DIR", "$ZOO_DATA_LOG_DIR"]


EXPOSE ${ZOO_PORT} 2888 3888


USER $ZOO_USER

WORKDIR $ZOO_HOME

ENTRYPOINT ["/opt/zookeeper/bin/docker-entrypoint.sh"]
CMD ["zkServer.sh", "start-foreground"]

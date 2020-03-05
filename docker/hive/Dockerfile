FROM lizhiyong2000/hadoop:2.8.3
#MAINTAINER Getty Images "https://github.com/gettyimages"

# HADOOP

ENV HIVE_VERSION=2.3.3 \
    HIVE_HOME=/opt/hive \
    HIVE_CONF_DIR=/opt/hive/conf \
    PATH=$PATH:/opt/hive/bin

WORKDIR $HIVE_HOME

RUN curl -fSL --retry 3 \
  "http://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz" \
  | tar --strip-components=1 -zxf - -C $HIVE_HOME \
 && rm -rf $HIVE_HOME/share/doc /tmp/* /var/tmp/* \
 && chown -R root:root $HIVE_HOME

ADD mysql-connector-java-5.1.46-bin.jar $HIVE_HOME/lib
COPY conf/hive-site.xml $HIVE_CONF_DIR/

COPY bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0775 /usr/local/bin/docker-entrypoint.sh 

# Hdfs ports
EXPOSE 10000 10002

USER root
# VOLUME ["$HIVE_HOME/data"]

ENV NODE_TYPE=hadoop-slave

# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["-d"]
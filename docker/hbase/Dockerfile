FROM lizhiyong2000/ubuntu:18.04
#MAINTAINER Getty Images "https://github.com/gettyimages"

# HADOOP

ENV HBASE_VERSION=2.1.0 \
    HBASE_HOME=/opt/hbase \
    HBASE_CONF_DIR=/opt/hbase/conf \
    HBASE_SERVER_TYPE=master \
    PATH=$PATH:/opt/hbase/bin

WORKDIR $HBASE_HOME

# http://www-eu.apache.org/dist/hbase/2.1.0/hbase-2.1.0-bin.tar.gz

RUN curl -fSL --retry 3 \
  "https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz" \
  # "http://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz" \
  | tar --strip-components=1 -zxf - -C $HBASE_HOME \
 && rm -rf $HBASE_HOME/share/doc /tmp/* /var/tmp/* \
 && chown -R root:root $HBASE_HOME

COPY conf/hbase-site.xml $HBASE_CONF_DIR/
COPY bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod 0775 /usr/local/bin/docker-entrypoint.sh 

# Hdfs ports
# EXPOSE 50010 50020 50070 50075 50090 8020 9000
EXPOSE 2181 8080 8085 9090 9095 16000 16010 16201 16301

USER root
# VOLUME ["$HBASE_HOME/data"]

# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["-d"]
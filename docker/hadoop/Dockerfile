FROM lizhiyong2000/ubuntu:18.04
#MAINTAINER Getty Images "https://github.com/gettyimages"

# HADOOP

ENV HADOOP_VERSION=2.8.3 \
    HADOOP_PREFIX=/opt/hadoop \
    HADOOP_HOME=/opt/hadoop \
    HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop \
    HADOOP_YARN_HOME=/opt/hadoop \ 
    YARN_CONF_DIR=/opt/hadoop/etc/hadoop \
    PATH=$PATH:/opt/hadoop/bin

WORKDIR $HADOOP_HOME

RUN curl -fSL --retry 3 \
  "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
  | tar --strip-components=1 -zxf - -C $HADOOP_HOME \
 && rm -rf $HADOOP_HOME/share/doc /tmp/* /var/tmp/* \
 && chown -R root:root $HADOOP_HOME

COPY conf/slaves conf/core-site.xml conf/hdfs-site.xml conf/mapred-site.xml conf/yarn-site.xml $HADOOP_CONF_DIR/
COPY bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN mkdir $HADOOP_HOME/data && mkdir $HADOOP_HOME/tmp && chmod 0775 /usr/local/bin/docker-entrypoint.sh 

# Hdfs ports
EXPOSE 8020 50070 50010 50020 50075
# Mapred ports
EXPOSE 10020 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122

USER root
VOLUME ["$HADOOP_HOME/data"]

# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["-d"]
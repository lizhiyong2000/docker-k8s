FROM lizhiyong2000/ubuntu:16.04
#MAINTAINER lizhiyong2000@gmail.com

# AMBARI

ENV AMBARI_VERSION=2.7.3 \
    AMBARI_HOME=/opt/ambari

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      python \
      python2.7 \
    && rm  /usr/bin/python && ln -s /usr/bin/python2.7 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir $AMBARI_HOME && cd $AMBARI_HOME 
COPY dist/ambari-agent_2.7.3.0-0.deb $AMBARI_HOME/


RUN dpkg -i $AMBARI_HOME/ambari-agent_2.7.3.0-0.deb

# COPY conf/slaves conf/core-site.xml conf/hdfs-site.xml conf/mapred-site.xml conf/yarn-site.xml $AMBARI_CONF_DIR/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

ADD init/init-agent.sh /opt/ambari/init-agent.sh
RUN chmod u+x /opt/ambari/init-agent.sh


ENV buildNumber=2.7.3.0
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
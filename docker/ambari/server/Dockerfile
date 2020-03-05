FROM lizhiyong2000/ubuntu:18.04
#MAINTAINER lizhiyong2000@gmail.com

# AMBARI

ENV AMBARI_VERSION=2.7.3 \
    AMBARI_HOME=/opt/ambari

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      python \
      python2.7 \
      postgresql \
    && rm  /usr/bin/python && ln -s /usr/bin/python2.7 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir $AMBARI_HOME && cd $AMBARI_HOME 
COPY dist/ambari-server_2.7.3.0-0-dist.deb $AMBARI_HOME/


RUN dpkg -i $AMBARI_HOME/ambari-server_2.7.3.0-0-dist.deb

# COPY conf/slaves conf/core-site.xml conf/hdfs-site.xml conf/mapred-site.xml conf/yarn-site.xml $AMBARI_CONF_DIR/


ADD init/init-server.sh /opt/ambari/init-server.sh
RUN chmod u+x /opt/ambari/init-server.sh


# RUN apt-get update \
#     && apt-get install --no-install-recommends -y systemd \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh


RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080 8440 8441 5432 5005

ENV buildNumber=2.7.3.0
# # ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# CMD ["/bin/bash"]
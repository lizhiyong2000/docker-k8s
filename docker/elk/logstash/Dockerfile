FROM lizhiyong2000/ubuntu:18.04
#MAINTAINER Zhiyong Li <lizhiyong2000@gmail.com>

ENV LOGSTASH_VERSION=6.3.0 \
    LOGSTASH_HOME=/opt/logstash \
    LOGSTASH_USER=logstash \
    LOGSTASH_PACKAGE=logstash-6.3.0 \
    ELASTIC_CONTAINER=true \
    LOGSTASH_CONF_DIR=/opt/logstash/conf \
    LOGSTASH_DATA_DIR=/opt/logstash/data \
    LOGSTASH_DATA_LOG_DIR=/opt/logstash/datalog \
    PATH=$PATH:/opt/logstash/bin \
    ELASTICSEARCH_URL="http://elasticsearch:9200"

WORKDIR $LOGSTASH_HOME

# Provide a non-root user to run the process.
RUN groupadd --gid 1000 $LOGSTASH_USER && \
    useradd --uid 1000 --gid 1000 --home-dir $LOGSTASH_HOME --no-create-home $LOGSTASH_USER && \
    curl -Lo - https://artifacts.elastic.co/downloads/logstash/$LOGSTASH_PACKAGE.tar.gz | \
    tar --strip-components=1 -zxf -  && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  && \
    mkdir $LOGSTASH_HOME/pipeline &&
    find $LOGSTASH_HOME -type d -exec chmod g+s {} \;



# Provide a minimal configuration, so that simple invocations will provide
# a good experience.
COPY --chown=1000:0 config/pipelines.yml config/pipelines.yml
COPY --chown=1000:0 config/logstash.yml config/logstash.yml
COPY --chown=1000:0 config/log4j2.properties config/log4j2.properties
COPY bin/docker-entrypoint /usr/local/bin/


RUN chown -R 1000:0 $LOGSTASH_HOME && \
    chmod -R g=u $LOGSTASH_HOME && \
    chmod 0755 /usr/local/bin/docker-entrypoint

USER logstash


EXPOSE 9600 5044

VOLUME ["$LOGSTASH_HOME/pipeline"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]

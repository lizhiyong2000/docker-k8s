################################################################################
# This Dockerfile was generated from the template at templates/Dockerfile.j2
#
# Beginning of multi stage Dockerfile
################################################################################


################################################################################
# Build stage 0 `prep_es_files`:
# Extract elasticsearch artifact
# Install required plugins
# Set gid=0 and make group perms==owner perms
################################################################################

FROM lizhiyong2000/ubuntu:18.04

# ElasticSearch
ENV ES_VERSION=6.3.0 \ 
    ES_PACKAGE=elasticsearch-6.3.0 \
    ES_HOME=/opt/elasticsearch \
    ES_CONF_DIR=/opt/elasticsearch/config \
    PATH=/opt/elasticsearch/bin:$PATH \
    ELASTIC_CONTAINER=true



WORKDIR $ES_HOME

# Download and extract defined ES version.
RUN curl -fSL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VERSION.tar.gz | \
    tar --strip-components=1 -zxf - -C $ES_HOME && \
    rm -rf /tmp/* /var/tmp/ && \
    for PLUGIN in ingest-user-agent ingest-geoip; do \
      $ES_HOME/bin/elasticsearch-plugin install --batch "$PLUGIN"; done  && \
    $ES_HOME/bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${ES_VERSION}/elasticsearch-analysis-ik-${ES_VERSION}.zip && \
    groupadd --gid 1000 elasticsearch && \
    useradd --uid 1000 --gid 1000 --home $ES_HOME --no-create-home elasticsearch && \
    set -ex && for esdirs in config data logs; do \
        mkdir -p "$esdirs"; \
    done 


COPY --chown=1000:0 elasticsearch.yml log4j2.properties config/
COPY --chown=1000:0 bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh



# Set gid to 0 for elasticsearch and make group permission similar to that of user
# This is needed, for example, for Openshift Open: https://docs.openshift.org/latest/creating_images/guidelines.html
# and allows ES to run with an uid
RUN chown -R elasticsearch:0 . && \
    chmod -R g=u $ES_HOME && \
    chmod g=u /etc/passwd && \
    chmod 0775 /usr/local/bin/docker-entrypoint.sh && ls -l $ES_HOME

EXPOSE 9200 9300

VOLUME ["$ES_HOME/data"]


USER elasticsearch

ENV ES_JAVA_OPTS="-Xms512m -Xmx512m" \ 
    CLUSTER_NAME=es-cluster \
    NODE_NAME=elasticsearch \
    NODE_MASTER=true \
    NODE_DATA=true \
    NODE_INGEST=true \
    HTTP_ENABLE=true \
    NETWORK_HOST=_site_ \
    NUMBER_OF_MASTERS=1 \
    DISCOVERY_SERVICE=es-data-svc



ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["eswrapper"]

################################################################################
# End of multi-stage Dockerfile
################################################################################

# This Dockerfile was generated from the template at templates/Dockerfile.j2
FROM lizhiyong2000/ubuntu:18.04
EXPOSE 5601

# Add Reporting dependencies.

ENV KIBANA_VERSION=6.3.0 \
    KIBANA_HOME=/opt/kibana \
    PATH=$PATH:/opt/kibana/bin \
    ELASTIC_CONTAINER=true

WORKDIR $KIBANA_HOME
# Set gid to 0 for kibana and make group permission similar to that of user
# This is needed, for example, for Openshift Open:
# https://docs.openshift.org/latest/creating_images/guidelines.html
# and allows Kibana to run with an uid
RUN curl -L https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar --strip-components=1 -zxf - && \
    chown -R 1000:0 . && \
    chmod -R g=u $KIBANA_HOME && \
    find $KIBANA_HOME -type d -exec chmod g+s {} \;

# Set some Kibana configuration defaults.
COPY --chown=1000:0 config/kibana.yml ${KIBANA_HOME}/config/kibana.yml

# Add the launcher/wrapper script. It knows how to interpret environment
# variables and translate them to Kibana CLI options.
COPY --chown=1000:0 bin/kibana-docker /usr/local/bin/

# Add a self-signed SSL certificate for use in examples.
COPY --chown=1000:0 ssl/kibana.example.org.* ${KIBANA_HOME}/config/

# Ensure gid 0 write permissions for Openshift.
RUN find ${KIBANA_HOME} -gid 0 -and -not -perm /g+w -exec chmod g+w {} \;

# Provide a non-root user to run the process.
RUN groupadd --gid 1000 kibana && \
    useradd --uid 1000 --gid 1000 --home-dir ${KIBANA_HOME} --no-create-home kibana  

RUN mkdir /var/log/kibana && chown 1000:0 /var/log/kibana

ENV ELASTICSEARCH_URL="http://es-ingest-svc:9200"

USER kibana

CMD ["/usr/local/bin/kibana-docker"]

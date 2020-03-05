FROM lizhiyong2000/ubuntu-sbt:0.13.17

#MAINTAINER Zhiyong Li <lizhiyong2000@gmail.com>

ARG kafka_manager_version=1.3.3.18
ARG kafka_manager_home=/opt/kafka_manager
ARG kafka_manager_build_path=/opt/kafka_manager_src

ENV KAFKA_MANAGER_VERSION=$kafka_manager_version \
    KAFKA_MANAGER_HOME=$kafka_manager_home \
    KAFKA_USER=kafka \
    PATH=${PATH}:${kafka_manager_home}/bin


WORKDIR $KAFKA_MANAGER_HOME
RUN groupadd --gid 1000 $KAFKA_USER \
    && useradd --uid 1000 --gid 1000 --home-dir $KAFKA_MANAGER_HOME --no-create-home $KAFKA_USER \
    && mkdir -p ${kafka_manager_build_path}


COPY --chown=1000:0 script/start-kafka-manager.sh ${KAFKA_MANAGER_HOME}/bin/

RUN chown -R kafka:0 . && \
    chmod -R g=u $KAFKA_MANAGER_HOME && \
    chmod g=u /etc/passwd && \
    chmod 0775 $KAFKA_MANAGER_HOME/bin/*.sh

# RUN mkdir -p $HOME/.sbt 
# COPY conf/repositories $HOME/.sbt/repositories


RUN curl -fSL "https://github.com/yahoo/kafka-manager/archive/${KAFKA_MANAGER_VERSION}.tar.gz"|tar --strip-components=1 -zxf - -C $kafka_manager_build_path 


RUN mkdir -p $HOME/.sbt/launchers/0.13.17 && cp /opt/sbt/bin/sbt-launch.jar $HOME/.sbt/launchers/0.13.17/
RUN cd $kafka_manager_build_path  && ./sbt -sbt-version 0.13.17 clean dist \
    && unzip $kafka_manager_build_path/target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip -d ${KAFKA_MANAGER_HOME} \
    && rm -rf /tmp/* /var/tmp/ 


RUN cp -R ${KAFKA_MANAGER_HOME}/kafka-manager-1.3.3.18/* $KAFKA_MANAGER_HOME/ && rm -Rf ${KAFKA_MANAGER_HOME}/kafka-manager-1.3.3.18

COPY --chown=1000:0 script/start-kafka-manager2.sh ${KAFKA_MANAGER_HOME}/bin/ 
RUN chmod 0775 $KAFKA_MANAGER_HOME/bin/*.sh

RUN chown -R $KAFKA_USER:$KAFKA_USER $KAFKA_MANAGER_HOME

USER $KAFKA_USER

EXPOSE 9000

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)


CMD ["start-kafka-manager2.sh"]

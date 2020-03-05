FROM lizhiyong2000/hadoop:2.8.3
#MAINTAINER Getty Images "https://github.com/gettyimages"

# HADOOP

ENV HADOOP_VERSION=2.8.3 \
    HADOOP_HOME=/opt/hadoop \ 
    SPARK_VERSION=2.3.0  \
    SPARK_HOME=/opt/spark

ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
    SPARK_PACKAGE=spark-$SPARK_VERSION-bin-without-hadoop.tgz \
    SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*" \
    PATH=$PATH:$HADOOP_HOME/bin:${SPARK_HOME}/bin 

# WORKDIR $HADOOP_HOME

# RUN curl -fSL --retry 3 \
#   "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
#   | tar --strip-components=1 -zxf - -C $HADOOP_HOME \
#  && rm -rf $HADOOP_HOME/share/doc /tmp/* /var/tmp/* \
#  && chown -R root:root $HADOOP_HOME
WORKDIR $SPARK_HOME

RUN curl -fSL --retry 3 "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}" \
  | tar --strip-components=1 -zxf - -C $SPARK_HOME \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
   && chown -R root:root $SPARK_HOME

COPY conf/spark-defaults.conf $SPARK_HOME/conf



CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]


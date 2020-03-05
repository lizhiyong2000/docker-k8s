#!/bin/bash

export HBASE_CONF_FILE=/opt/hbase/conf/hbase-site.xml
export HADOOP_USER_NAME=root
export HBASE_MANAGES_ZK=true

# sed -i "s/@HDFS_PATH@/$HDFS_PATH/g" $HBASE_CONF_FILE
# sed -i "s/@ZOOKEEPER_IP_LIST@/$ZOOKEEPER_SERVICE_LIST/g" $HBASE_CONF_FILE
# sed -i "s/@ZOOKEEPER_PORT@/$ZOOKEEPER_PORT/g" $HBASE_CONF_FILE
# sed -i "s/@ZNODE_PARENT@/$ZNODE_PARENT/g" $HBASE_CONF_FILE

# set fqdn
# for i in $(seq 1 10)
# do
#     if grep --quiet $CLUSTER_DOMAIN /etc/hosts; then
#         break
#     elif grep --quiet $POD_NAME /etc/hosts; then
#         cat /etc/hosts | sed "s/$POD_NAME/${POD_NAME}.${POD_NAMESPACE}.svc.${CLUSTER_DOMAIN} $POD_NAME/g" > /etc/hosts.bak
#         cat /etc/hosts.bak > /etc/hosts
#         break
#     else
#         echo "waiting for /etc/hosts ready"
#         sleep 1
#     fi
# done

# if [ "$HBASE_SERVER_TYPE" = "master" ]; then
#     /opt/hbase/bin/hbase master start
# elif [ "$HBASE_SERVER_TYPE" = "regionserver" ]; then
#     /opt/hbase/bin/hbase regionserver start
# fi

if [[ ! -d "${HBASE_HOME}/logs" ]]; then
  mkdir ${HBASE_HOME}/logs
fi


echo "Starting local Zookeeper"
$HBASE_HOME/bin/hbase zookeeper &>${HBASE_HOME}/logs/zookeeper.log &

echo "Starting HBase"
$HBASE_HOME/bin/start-hbase.sh

# HBase versions < 1.0 fail to start RegionServer without SSH being installed
echo "Starting local RegionServer"
$HBASE_HOME/bin/local-regionservers.sh start 1

echo "Starting HBase Stargate Rest API server"
$HBASE_HOME/bin/hbase-daemon.sh start rest

# echo "Starting HBase Thrift API server"
# /hbase/bin/hbase-daemon.sh start thrift


if [[ $1 == "-d" ]]; then
  until find ${HBASE_HOME}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
  tail -F ${HBASE_HOME}/logs/* &
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

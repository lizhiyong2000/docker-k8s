#!/bin/bash

: ${HADOOP_HOME:=/opt/hadoop}

if [[ -z "${NODE_TYPE}" ]]; then
  echo "ENV NODE_TYPE not set"
  exit -1
fi

# . $HADOOP_HOME/etc/hadoop/hadoop-env.sh


# # installing libraries if any - (resource urls added comma separated to the ACP system variable)
# cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -


########## namenode ##########
if [[ "${NODE_TYPE}" =~ "namenode" ]]; then

  if [[ ! -f "$HADOOP_HOME/namenode_formated" ]]; then

    $HADOOP_HOME/bin/hdfs namenode -format -force -nonInteractive

    touch "$HADOOP_HOME/namenode_formated"

  fi 

  
  sed -i s/namenode-0.namenode-svc/0.0.0.0/ $HADOOP_HOME/etc/hadoop/core-site.xml
  $HADOOP_HOME/sbin/hadoop-daemon.sh start namenode

fi

########## datanode ##########
if [[ "${NODE_TYPE}" =~ "datanode" ]]; then
  $HADOOP_HOME/sbin/hadoop-daemon.sh start datanode
 
fi

########## resourcemanager ##########
if [[ "${NODE_TYPE}" =~ "resourcemanager" ]]; then
   sed -i s/resourcemanager-0.resourcemanager-svc/0.0.0.0/ $HADOOP_HOME/etc/hadoop/yarn-site.xml
   $HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager

fi


########## nodemanager ##########
if [[ "${NODE_TYPE}" =~ "nodemanager" ]]; then
  sed -i '/<\/configuration>/d' $HADOOP_HOME/etc/hadoop/yarn-site.xml
  cat >> $HADOOP_HOME/etc/hadoop/yarn-site.xml <<- EOM
  <property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>${MY_MEM_LIMIT:-1024}</value>
  </property>

  <property>
    <name>yarn.nodemanager.resource.cpu-vcores</name>
    <value>${MY_CPU_LIMIT:-1}</value>
  </property>
EOM
  echo '</configuration>' >> $HADOOP_HOME/etc/hadoop/yarn-site.xml
  $HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager
fi


########## historyserver ##########
if [[ "${NODE_TYPE}" =~ "historyserver" ]]; then
  $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
 
fi




if [[ $1 == "-d" ]]; then
  until find ${HADOOP_HOME}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
  tail -F ${HADOOP_HOME}/logs/* &
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

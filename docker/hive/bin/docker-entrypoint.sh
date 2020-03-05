#!/bin/bash

hadoop fs -mkdir /tmp
hadoop fs -mkdir -p /user/hive/warehouse
hadoop fs -chmod g+w /tmp
hadoop fs -chmod g+w /user/hive/warehouse

# start metastore
hive --service metastore


hive 

# if [[ $1 == "-d" ]]; then
#   while true; do sleep 1000; done
# fi

# if [[ $1 == "-bash" ]]; then
#   /bin/bash
# fi
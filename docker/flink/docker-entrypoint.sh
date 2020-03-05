#!/bin/bash

################################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

# jobmanager or taskmanager

echo $@
FLINK_COMPONENT=$1
shift

FLINK_CONFIG=$FLINK_HOME/conf/flink-conf.yaml

function set_config_property {
    key=$1
    value=$2
    grep -qe "^#*\s*$key:" $FLINK_CONFIG && sed -ir "s~^#*\s*$key:.*~$key: $value~" $FLINK_CONFIG || echo -e "$key: $value\n" >> $FLINK_CONFIG
}

function setup_config {
    for i in "$@"
    do
        set_config_property ${i%=*} ${i#*=}
        shift
    done

    echo "config file: " && grep '^[^\n#]' $FLINK_CONFIG
}

# Set default config values
set_config_property "jobmanager.rpc.address" "flink-jobmanager"

echo $@

if [ "$FLINK_COMPONENT" = "jobmanager" ]; then
    # Override config params form command line arguments
    setup_config "$@"

    $FLINK_HOME/bin/jobmanager.sh start cluster
elif [ "$FLINK_COMPONENT" = "taskmanager" ]; then
    set_config_property "taskmanager.numberOfTaskSlots" `grep -c ^processor /proc/cpuinfo`
    
    # Override config params from command line arguments
    setup_config "$@"
    
    $FLINK_HOME/bin/taskmanager.sh start
else
    $@
fi


while true; do sleep 1000; done


if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
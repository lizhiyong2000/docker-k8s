#!/bin/bash 
set -e

# Allow specific kafka versions to perform any unique bootstrap operations
# OVERRIDE_FILE="/opt/overrides/${KAFKA_VERSION}.sh"
# if [[ -x "$OVERRIDE_FILE" ]]; then
#     echo "Executing override file $OVERRIDE_FILE"
#     eval "$OVERRIDE_FILE"
# fi

# Store original IFS config, so we can restore it at various stages
ORIG_IFS=$IFS


HOST=`hostname -s`
DOMAIN=`hostname -d`
ZOO_CLIENT_PORT=${ZOO_CLIENT_PORT:-2181}
ZOO_HOST_NAME=${ZOO_HOST_NAME:-"zookeeper"}
ZOO_SERVICE_NAME=${ZOO_SERVICE_NAME:-"zookeeper-svc"}
ZOO_DOMAIN_NAME=${ZOO_DOMAIN_NAME:-"default.svc.cluster.local"}
ZOO_REPLICAS=${ZOO_REPLICAS: -0}

KAFKA_HOME=${KAFKA_HOME:-"/opt/kafka"}
KAFKA_PORT=${KAFKA_PORT:-9092}
KAFKA_BROKER_ID=${KAFKA_BROKER_ID: -1}
KAFKA_LOG_DIRS=${KAFKA_LOG_DIRS:-"${KAFKA_HOME}/logs"}
# KAFKA_HEAP_OPTS="${KAFKA_HEAP_OPTS:-Xms512m -Xmx512m}"
KAFKA_LISTENERS=${KAFKA_LISTENERS: -"PLAINTEXT://:9092"}
KAFKA_ADVERTISED_LISTENERS=${KAFKA_ADVERTISED_LISTENERS: -"PLAINTEXT://:9092"}

KAFKA_REPLICAS=${KAFKA_REPLICAS: -1}



function config_zookeeper_servers() {

    local server

    if [[ $ZOO_REPLICAS -gt 0 ]]; then

        for (( i=1; i<=$ZOO_REPLICAS; i++ ))
        do
            server=${ZOO_HOST_NAME}-$((i-1)).${ZOO_SERVICE_NAME}.${ZOO_DOMAIN_NAME}:${ZOO_CLIENT_PORT}
            if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
                KAFKA_ZOOKEEPER_CONNECT=${server}
            else
                KAFKA_ZOOKEEPER_CONNECT=${KAFKA_ZOOKEEPER_CONNECT},${server}
            fi
            
        done
    else
        KAFKA_ZOOKEEPER_CONNECT="localhost:2181"
    fi

    export KAFKA_ZOOKEEPER_CONNECT

}


function validate_env() {
    echo "Validating environment"

    # if [ -z $KAFKA_REPLICAS ]; then
    #     echo "KAFKA_REPLICAS is a mandatory environment variable"
    #     exit 1
    # fi

    # if [ -z $ZOO_REPLICAS ]; then
    #     echo "ZOO_REPLICAS is a mandatory environment variable"
    #     exit 1
    # fi



    if [[ $HOST =~ (.*)-([0-9]+)$ ]]; then
        NAME=${BASH_REMATCH[1]}
        ORD=${BASH_REMATCH[2]}
    else
       
       if [[ $KAFKA_REPLICAS -gt 1 ]]; then
            echo "Failed to extract ordinal from hostname $HOST"
            exit 1
       fi
        
    fi

    if [[ $KAFKA_REPLICAS -gt 1 ]]; then
        KAFKA_BROKER_ID=$((ORD+1))
    else
        KAFKA_BROKER_ID=1
    fi

    export KAFKA_BROKER_ID

    echo "KAFKA_BROKER_ID=$KAFKA_BROKER_ID"
    echo "KAFKA_HOME=$KAFKA_HOME"
    echo "KAFKA_PORT=$KAFKA_PORT"
    echo "KAFKA_REPLICAS=$KAFKA_REPLICAS"

    echo "ZOO_REPLICAS=$ZOO_REPLICAS"
    echo "ZOOKEEPER ENSEMBLE"

    config_zookeeper_servers

    echo "KAFKA_ZOOKEEPER_CONNECT=$KAFKA_ZOOKEEPER_CONNECT"
    if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
        echo "ERROR: missing mandatory config: KAFKA_ZOOKEEPER_CONNECT"
        exit 1
    fi

    

    if [[ -n "$KAFKA_HEAP_OPTS" ]]; then
        sed -r -i 's/(export KAFKA_HEAP_OPTS)="(.*)"/\1="'"$KAFKA_HEAP_OPTS"'"/g' "$KAFKA_HOME/bin/kafka-server-start.sh"
        unset KAFKA_HEAP_OPTS
    fi

    echo "Environment validation successful"
}







# create-topics.sh &
# unset KAFKA_CREATE_TOPICS

# # DEPRECATED: but maintained for compatibility with older brokers pre 0.9.0 (https://issues.apache.org/jira/browse/KAFKA-1809)
# if [[ -z "$KAFKA_ADVERTISED_PORT" && \
#   -z "$KAFKA_LISTENERS" && \
#   -z "$KAFKA_ADVERTISED_LISTENERS" && \
#   -S /var/run/docker.sock ]]; then
#     KAFKA_ADVERTISED_PORT=$(docker port "$(hostname)" $KAFKA_PORT | sed -r 's/.*:(.*)/\1/g')
#     export KAFKA_ADVERTISED_PORT
# fi



# if [[ -z "$KAFKA_LOG_DIRS" ]]; then
#     export KAFKA_LOG_DIRS="$KAFKA_HOME/logs"
# fi



# if [[ -n "$HOSTNAME_COMMAND" ]]; then
#     HOSTNAME_VALUE=$(eval "$HOSTNAME_COMMAND")

#     # Replace any occurences of _{HOSTNAME_COMMAND} with the value
#     IFS=$'\n'
#     for VAR in $(env); do
#         if [[ $VAR =~ ^KAFKA_ && "$VAR" =~ "_{HOSTNAME_COMMAND}" ]]; then
#             eval "export ${VAR//_\{HOSTNAME_COMMAND\}/$HOSTNAME_VALUE}"
#         fi
#     done
#     IFS=$ORIG_IFS
# fi

# if [[ -n "$PORT_COMMAND" ]]; then
#     PORT_VALUE=$(eval "$PORT_COMMAND")

#     # Replace any occurences of _{PORT_COMMAND} with the value
#     IFS=$'\n'
#     for VAR in $(env); do
#         if [[ $VAR =~ ^KAFKA_ && "$VAR" =~ "_{PORT_COMMAND}" ]]; then
# 	    eval "export ${VAR//_\{PORT_COMMAND\}/$PORT_VALUE}"
#         fi
#     done
#     IFS=$ORIG_IFS
# fi

# if [[ -n "$RACK_COMMAND" && -z "$KAFKA_BROKER_RACK" ]]; then
#     KAFKA_BROKER_RACK=$(eval "$RACK_COMMAND")
#     export KAFKA_BROKER_RACK
# fi




function updateConfig() {
    key=$1
    value=$2
    file=$3

    # Omit $value here, in case there is sensitive information
    echo "[Configuring] '$key' in '$file'"

    # If config exists in file, replace it. Otherwise, append to file.
    if grep -E -q "^#?$key=" "$file"; then
        sed -r -i "s@^#?$key=.*@$key=$value@g" "$file" #note that no config values may contain an '@' char
    else
        echo "$key=$value" >> "$file"
    fi
}

function create_config(){
    #Issue newline to config file in case there is not one already
    echo "" >> "$KAFKA_HOME/config/server.properties"

       # Fixes #312
    # KAFKA_VERSION + KAFKA_HOME + grep -rohe KAFKA[A-Z0-0_]* /opt/kafka/bin | sort | uniq | tr '\n' '|'
    EXCLUSIONS="|KAFKA_REPLICAS|KAFKA_VERSION|KAFKA_HOME|KAFKA_DEBUG|KAFKA_GC_LOG_OPTS|KAFKA_HEAP_OPTS|KAFKA_JMX_OPTS|KAFKA_JVM_PERFORMANCE_OPTS|KAFKA_LOG|KAFKA_OPTS|"

    # Read in env as a new-line separated array. This handles the case of env variables have spaces and/or carriage returns. See #313
    IFS=$'\n'
    for VAR in $(env)
    do
        env_var=$(echo "$VAR" | cut -d= -f1)
        if [[ "$EXCLUSIONS" = *"|$env_var|"* ]]; then
            echo "Excluding $env_var from broker config"
            continue
        fi

        if [[ $env_var =~ ^KAFKA_ ]]; then
            kafka_name=$(echo "$env_var" | cut -d_ -f2- | tr '[:upper:]' '[:lower:]' | tr _ .)
            updateConfig "$kafka_name" "${!env_var}" "$KAFKA_HOME/config/server.properties"
        fi

        if [[ $env_var =~ ^LOG4J_ ]]; then
            log4j_name=$(echo "$env_var" | tr '[:upper:]' '[:lower:]' | tr _ .)
            updateConfig "$log4j_name" "${!env_var}" "$KAFKA_HOME/config/log4j.properties"
        fi
    done

    EXTERNAL_LISTENER_PORT=$((30093 + ${HOSTNAME##*-}))

    echo "EXTERNAL_LISTENER_PORT=$EXTERNAL_LISTENER_PORT"

    # sed -i "s/#listeners=PLAINTEXT:\/\/:9092/listeners=INTERNAL_PLAINTEXT:\/\/0.0.0.0:9092,EXTERNAL_PLAINTEXT:\/\/0.0.0.0:9093/" /etc/kafka/server.properties
    sed -i "s/127.0.0.1:9092/${HOSTNAME}.broker.default.svc.cluster.local:9092/" "${KAFKA_HOME}/config/server.properties"
    sed -i "s/192.168.2.42:9093/192.168.2.42:${EXTERNAL_LISTENER_PORT}/" "${KAFKA_HOME}/config/server.properties"

    cat "$KAFKA_HOME/config/server.properties"

}

# if [[ -n "$CUSTOM_INIT_SCRIPT" ]] ; then
#   eval "$CUSTOM_INIT_SCRIPT"
# fi

validate_env && create_config

exec "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/config/server.properties"

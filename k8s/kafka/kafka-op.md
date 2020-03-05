kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm /bin/sh
kubectl label pods ${HOSTNAME} kafka-set-component=${HOSTNAME}

ports:
    - containerPort: 9092
    - containerPort: 9093
    env:
    - name: KAFKA_ZOOKEEPER_CONNECT
      value: "zookeeper:2181"
    - name: KAFKA_LISTENER_SECURITY_PROTOCOL_MAP
      value: "INTERNAL_PLAINTEXT:PLAINTEXT,EXTERNAL_PLAINTEXT:PLAINTEXT"
    - name: KAFKA_ADVERTISED_LISTENERS
      value: "INTERNAL_PLAINTEXT://kafka-internal-service:9092,EXTERNAL_PLAINTEXT://123.us-east-2.elb.amazonaws.com:9093"
    - name: KAFKA_LISTENERS
      value: "INTERNAL_PLAINTEXT://0.0.0.0:9092,EXTERNAL_PLAINTEXT://0.0.0.0:9093"
    - name: KAFKA_INTER_BROKER_LISTENER_NAME
      value: "INTERNAL_PLAINTEXT"



zookeeper-0.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-1.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-2.zookeeper-svc.default.svc.cluster.local:2181



bin/kafka-topics.sh --zookeeper zookeeper-0.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-1.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-2.zookeeper-svc.default.svc.cluster.local:2181 --delete  --topic meetup-raw-rsvps 





bin/kafka-topics.sh --zookeeper zookeeper-0.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-1.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-2.zookeeper-svc.default.svc.cluster.local:2181 --create  --topic meetup-raw-rsvps-3 --partitions 1 --replication-factor 1


bin/kafka-topics.sh --zookeeper zookeeper-0.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-1.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-2.zookeeper-svc.default.svc.cluster.local:2181 --list


bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --topic meetup-raw-rsvps --zookeeper zookeeper-0.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-1.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-2.zookeeper-svc.default.svc.cluster.local:2181
    --group test_group

bin/kafka-console-consumer.sh --zookeeper zookeeper-0.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-1.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-2.zookeeper-svc.default.svc.cluster.local:2181 --from-beginning --topic meetup-raw-rsvps


bin/kafka-console-consumer.sh --bootstrap-server kafka-0.kafka-svc.default.svc.cluster.local:9092,kafka-1.kafka-svc.default.svc.cluster.local:9092,kafka-2.kafka-svc.default.svc.cluster.local:9092  --topic meetup-raw-rsvps --from-beginning  




./zookeeper-shell.sh zookeeper-0.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-1.zookeeper-svc.default.svc.cluster.local:2181,zookeeper-2.zookeeper-svc.default.svc.cluster.local:2181

ls  /brokers/topics

rmr /brokers/topics/meetup-raw-rsvps
rmr /brokers/topics/meetup-raw-rsvps-2
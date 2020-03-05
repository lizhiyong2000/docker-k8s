FROM lizhiyong2000/ubuntu:18.04

# Install RabbitMQ.
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends erlang-nox \
    && wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | apt-key add - \
    && echo "deb https://dl.bintray.com/rabbitmq/debian bionic main" | tee /etc/apt/sources.list.d/bintray.rabbitmq.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server \
    && rm -rf /var/lib/apt/lists/* \
    && rabbitmq-plugins enable rabbitmq_management \
    # && rabbitmqctl add_user admin admin \
    # && rabbitmqctl set_user_tags admin administrator \
    # && rabbitmqctl  set_permissions -p / admin '.*' '.*' '.*' \
    && echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config 


# Define mount points.
VOLUME ["/etc/rabbitmq", "/var/lib/rabbitmq/mnesia"]




# Expose ports.
EXPOSE 4369 5672 15672 25672

USER rabbitmq

WORKDIR /var/lib/rabbitmq

CMD ["rabbitmq-server"]

FROM fluent/fluentd:v0.12.24
MAINTAINER Damien Garros <dgarros@gmail.com>

ENV FLUENTD_JUNIPER_VERSION 0.2.11

USER root
WORKDIR /home/fluent

## Install python
RUN apk update \
    && apk add python-dev py-pip bash tcpdump\
    && pip install --upgrade pip \
    && pip install envtpl \
    && apk del -r --purge gcc make g++ \
    && rm -rf /var/cache/apk/*


ENV PATH /home/fluent/.gem/ruby/2.2.0/bin:$PATH

RUN apk --no-cache --update add \
                            build-base \
                            ruby-dev && \
    echo 'gem: --no-document' >> /etc/gemrc && \
    gem install --no-ri --no-rdoc \
              fluent-plugin-splunk-ex \
              protobuf \
              bigdecimal && \
    apk del build-base ruby-dev && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN gem install --no-ri --no-rdoc \
            fluent-plugin-juniper-telemetry -v ${FLUENTD_JUNIPER_VERSION}

# Copy Start script to generate configuration dynamically
ADD     fluentd-alpine.start.sh         fluentd-alpine.start.sh
RUN     chown -R fluent:fluent fluentd-alpine.start.sh
RUN     chmod 777 fluentd-alpine.start.sh

USER fluent
EXPOSE 24284

ENV OUTPUT_KAFKA=false \
    OUTPUT_INFLUXDB=false \
    OUTPUT_STDOUT=false \
    OUTPUT_JSON=true\
    PORT_JTI=50000 \
    PORT_ANALYTICSD=50020 \
    INFLUXDB_ADDR=localhost \
    INFLUXDB_PORT=8086 \
    INFLUXDB_DB=juniper \
    INFLUXDB_USER=juniper \
    INFLUXDB_PWD=juniper \
    INFLUXDB_FLUSH_INTERVAL=2 \
    JSON_ADDR=localhost\
    JSON_PORT=9997\
    KAFKA_ADDR=localhost \
    KAFKA_PORT=9092 \
    KAFKA_DATA_TYPE=json \
    KAFKA_TOPIC=jnpr.jvision

CMD /home/fluent/fluentd-alpine.start.sh

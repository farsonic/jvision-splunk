FROM phusion/baseimage:0.9.18
MAINTAINER Damien Garros <dgarros@gmail.com>

RUN     apt-get -y update && \
        apt-get -y upgrade && \
        apt-get clean   &&\
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# dependencies
RUN     apt-get -y update && \
        apt-get -y install \
        git adduser libfontconfig wget make curl  && \
        apt-get clean   &&\
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Latest version
ENV FLUENTD_VERSION 0.12.20
ENV FLUENTD_JUNIPER_VERSION 0.2.10

RUN     apt-get -y update && \
        apt-get -y install \
            build-essential \
            tcpdump \
            ruby \
            ruby-dev \
            python-dev \
            python-pip

########################
### Install Fluentd  ###
########################

# RUN     gem install fluentd fluent-plugin-influxdb --no-ri --no-rdoc
RUN     gem install --no-ri --no-rdoc \
            fluentd -v ${FLUENTD_VERSION} && \
        gem install --no-ri --no-rdoc \
            influxdb \
            rake \
            bundler \
            protobuf \
            statsd-ruby \
            dogstatsd-ruby \
            fluent-plugin-kafka && \
        gem install --no-ri --no-rdoc \
            fluent-plugin-juniper-telemetry -v ${FLUENTD_JUNIPER_VERSION}

RUN     pip install envtpl

RUN     mkdir /root/fluent

RUN     mkdir /etc/fluent && \
        mkdir /etc/fluent/plugin

ADD     fluentd/plugin/out_influxdb.rb       /etc/fluent/plugin/out_influxdb.rb
ADD     fluentd/plugin/out_statsd.rb         /etc/fluent/plugin/out_statsd.rb

WORKDIR /root
ENV HOME /root

ADD     fluentd/fluentd.launcher.sh /etc/service/fluentd/run
RUN     chmod +x /etc/service/fluentd/run

ADD     fluentd/fluentd.start.sh /root/fluentd.start.sh
RUN     chmod +x /root/fluentd.start.sh

RUN     chmod -R 777 /var/log/

ENV OUTPUT_KAFKA=false \
    OUTPUT_INFLUXDB=true \
    OUTPUT_STDOUT=false \
    PORT_JTI=50000 \
    PORT_ANALYTICSD=50020 \
    INFLUXDB_ADDR=localhost \
    INFLUXDB_PORT=8086 \
    INFLUXDB_DB=juniper \
    INFLUXDB_USER=juniper \
    INFLUXDB_PWD=juniper \
    KAFKA_ADDR=localhost \
    KAFKA_PORT=9092 \
    KAFKA_DATA_TYPE=json \
    KAFKA_TOPIC=jnpr.jvision

EXPOSE 24220

CMD ["/sbin/my_init"]

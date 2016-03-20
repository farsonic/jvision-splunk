FROM phusion/baseimage:0.9.18
MAINTAINER Damien Garros <dgarros@gmail.com>

RUN     apt-get -y update && \
        apt-get -y upgrade

# dependencies
RUN     apt-get -y --force-yes install \
        git adduser libfontconfig wget make curl

# Latest version
ENV FLUENTD_VERSION 0.12.20
ENV FLUENTD_JUNIPER_VERSION 0.2.6-beta

RUN     apt-get -y update && \
        apt-get -y install \
            build-essential \
            tcpdump \
            ruby \
            ruby-dev

RUN     mkdir /src

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
            dogstatsd-ruby

ADD     docker/fluentd/fluentd.launcher.sh /etc/service/fluentd/run

########################
### Configuration    ###
########################

RUN     chmod +x /etc/service/fluentd/run

#######
### Copy files that change often
######

RUN     mkdir /etc/fluent && \
        mkdir /etc/fluent/plugin

ADD     docker/fluentd/fluent.conf /etc/fluent/fluent.conf
ADD     docker/fluentd/fluent.conf /fluent/fluent.conf
RUN     fluentd --setup

ADD     docker/fluentd/plugin/out_influxdb.rb       /etc/fluent/plugin/out_influxdb.rb
ADD     docker/fluentd/plugin/out_statsd.rb         /etc/fluent/plugin/out_statsd.rb

WORKDIR /tmp
RUN     wget -O /tmp/fluent-plugin-juniper-telemetry.tar.gz https://github.com/JNPRAutomate/fluent-plugin-juniper-telemetry/archive/v${FLUENTD_JUNIPER_VERSION}.tar.gz &&\
        tar -xzf /tmp/fluent-plugin-juniper-telemetry.tar.gz                &&\
        cd /tmp/fluent-plugin-juniper-telemetry-${FLUENTD_JUNIPER_VERSION}  &&\
        rake install

RUN     apt-get clean   &&\
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /
ENV HOME /root

RUN chmod -R 777 /var/log/

ENV INFLUXDB_ADDR=localhost \
    INFLUXDB_DB=juniper \
    INFLUXDB_USER=juniper \
    INFLUXDB_PWD=juniper \
    PORT_JTI=50000 \
    PORT_NA=50010 \
    PORT_ANALYTICSD=50020

EXPOSE ${PORT_JTI}/udp \
       ${PORT_NA}/udp \
       ${PORT_ANALYTICSD}/udp \
       24220

CMD ["/sbin/my_init"]

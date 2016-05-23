#! /bin/bash

docker run --rm -t \
        -e OUTPUT_INFLUXDB="false" \
        -e OUTPUT_KAFKA="true" \
        -e OUTPUT_STDOUT="true" \
        -e INFLUXDB_ADDR="172.17.0.3" \
        -e KAFKA_ADDR="172.29.110.168" \
        -e KAFKA_TOPIC="jnpr.jvision" \
        -e PORT_JTI='40000' \
        -e PORT_ANALYTICSD='40020' \
        -p 40000:40000/udp \
        -p 40020:40020/udp \
        -i juniper/open-nti-input-jti /bin/sh

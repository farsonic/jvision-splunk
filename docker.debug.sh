#! /bin/bash

docker run --rm -t \
        -e INFLUXDB_ADDR="172.17.0.3" \
        -e KAFKA_ADDR="172.17.0.2" \
        -e OUTPUT_KAFKA="true" \
        -e OUTPUT_INFLUXDB="false" \
        -e PORT_JTI='40000' \
        -p 40000:40000/udp \
        --volume $(pwd):/root/fluent \
        -i juniper/open-nti-input-jti /sbin/my_init -- bash -l

#! /bin/bash

docker run --rm -t \
        -e OUTPUT_INFLUXDB="false" \
        -e OUTPUT_JSON="true" \
        -e OUTPUT_STDOUT="true" \
        -e PORT_JTI='50000' \
        -e PORT_ANALYTICSD='50020' \
        -e JSON_ADDR='172.29.110.16' \
        -e JSON_PORT='9997' \
        -p 50000:50000/udp \
        -p 50020:50020/udp \
        -i juniper/open-nti-json-output

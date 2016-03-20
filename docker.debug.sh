#! /bin/bash

docker run --rm -t \
        -e INFLUXDB_ADDR='localhost' \
        -i juniper/open-nti-input-jti /sbin/my_init -- bash -l

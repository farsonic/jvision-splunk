
docker run -d -p 2181:2181 \
            -p 9092:9092 \
            --env ADVERTISED_PORT=9092 \
            --env ADVERTISED_HOST="172.29.110.168" \
            spotify/kafka

          #  --env ADVERTISED_HOST= \

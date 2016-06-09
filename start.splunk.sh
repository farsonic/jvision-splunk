
docker run --hostname splunk \
           -p 8000:8000 \
           -p 9997:9997 \
           -d \
           --env SPLUNK_START_ARGS="--accept-license" \
           --env SPLUNK_CMD='edit user admin -password jvision -role admin -auth admin:changeme' \
           outcoldman/splunk:6.4.1

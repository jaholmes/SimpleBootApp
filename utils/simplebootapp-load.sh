#!/bin/bash
i="0"

while [ true ]
do
    curl --fail --silent --show-error \
        --request GET \
        http://${1}/env
    sleep 1
    curl --fail --silent --show-error \
        --request GET \
        http://${1}/beans
    i=$[$i+1]
done

#!/bin/bash

rm -rf aflplusplus_docker/harnesses \
    && docker build . -t harness-base \
    && docker run -d --name build-harnesses harness-base sleep infinity \
    && docker cp build-harnesses:/app/harnesses ./aflplusplus_docker \
    && docker kill build-harnesses \
    && docker rm build-harnesses

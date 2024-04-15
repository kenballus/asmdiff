#!/bin/bash

rm -rf aflplusplus_docker/targets \
    && mkdir aflplusplus_docker/targets \
    && docker build . -t target-base \
    && docker run -d --name build-harnesses target-base sleep infinity \
    && docker cp build-harnesses:/app/targets ./aflplusplus_docker \
    && docker kill build-harnesses \
    && docker rm build-harnesses

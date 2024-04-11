#!/bin/bash

docker run -d --name temp-target target-base
docker cp -r temp-target:/app/targets ./aflplusplus_docker/targets 
docker rm temp-target
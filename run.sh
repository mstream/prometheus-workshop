#!/usr/bin/env bash -e

docker build -t 'local/prometheus:1.0' .
docker build -t 'local/service:1.0' service
docker-compose up

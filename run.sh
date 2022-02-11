#!/usr/bin/env bash -e

function list_docker_containers_loop() {
  while true; do
    printf "\n===\n" 
    sleep 5
    status=$(docker ps --format "table {{.Names}}\t{{.Ports}}")
    printf "===\n" 
  done;
}

docker build -t 'local/prometheus:1.0' .
docker build -t 'local/service:1.0' service

(sleep 5 && list_docker_containers_loop) &

docker-compose up

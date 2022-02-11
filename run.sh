#!/usr/bin/env bash -e

usage() { 
  printf "%s usage:\n-f    skip tests\n-h    help\n" "$0"
}

list_docker_containers_loop() {
  while true; do
    sleep 5
    status=$(docker ps --format "table {{.Names}}\t{{.Ports}}")
    printf "\n===\n%s\n===\n" "${status}"
  done;
}

while getopts "fh" arg; do
  case $arg in
    f)
      skip_tests="yes" 
      ;;
    h) 
      usage
      exit 0
      ;;
  esac
done

docker build -t 'local/prometheus:1.0' . --build-arg "SKIP_TESTS=${skip_tests}"
docker build -t 'local/service:1.0' service

(sleep 5 && list_docker_containers_loop) &

docker-compose up

FROM prom/prometheus:v2.30.0

COPY configs/ /etc/prometheus/
COPY rules/ /etc/prometheus/rules/

RUN promtool check config /etc/prometheus/*.yml
RUN promtool test rules /etc/prometheus/rules/alerts/*.test.yml
RUN promtool test rules /etc/prometheus/rules/recording/*.test.yml

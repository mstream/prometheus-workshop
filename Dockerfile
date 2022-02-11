FROM prom/prometheus:v2.30.0

ARG SKIP_TESTS

COPY configs/ /etc/prometheus/
COPY rules/ /etc/prometheus/rules/

RUN if [[ -z "${SKIP_TESTS}" ]] ; then promtool check config /etc/prometheus/*.yml; else echo skipping tests... ; fi
RUN if [[ -z "${SKIP_TESTS}" ]] ; then promtool test rules /etc/prometheus/rules/alerts/*.test.yml; else echo skipping tests... ; fi
RUN if [[ -z "${SKIP_TESTS}" ]] ; then promtool test rules /etc/prometheus/rules/recording/*.test.yml; else echo skipping tests... ; fi

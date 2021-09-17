# Prometheus Workshop


## Instructions

Execute `./run.sh` command to run unit tests and start up prometheus,
alertmanager and a mock serice containers.


## Tasks

### Implement an alert based on service availability

Rule file path: `rules/alerts/instance-health-rules.yml`

Whenever there is a service instance not available for 2 minutes or more, 
an alert called `Instance_Down` should be raised.

Hints:
* use `for` to trigger alert only if a condition lasts for a certain amount of time
* use a build in `labels` variable to reference labels from a given expression


### Implement an alert based on service response codes

Rule file path: `rules/alerts/errors-rules.yml`

Whenever the rate of errors is over 25%, an alert called `High_Error_Rate`
should be raised.

Hints:
* use a build in `value` variable to reference the value of a given expression
* convert the value into percents to improve human readibility


### Implement a recording rule based on service response latency histogram

Rule file path: `rules/recording/ovp-metrics-rules.yml`

There should be three metrics derived from a histogram called 
`z_application_latency_seconds_bucket`:
* `application_latency_50` (the 50th percentile of response times)
* `application_latency_98` (the 98th percentile of response times)
* `application_response_rate` (responses produced a minute)

Hints:
* use `histogram_quantile` function for the quantiles calculation
* use the metric with `le="+Inf"` label to derive the response rate

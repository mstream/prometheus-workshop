const http = require('http');

const latencyBuckets = {
  '0.5': 0,
  '1.0': 0,
  '1.5': 0,
  '2.0': 0,
  '+Inf': 0,
};

const responseCounts = {
  '2XX': 0,
  '4XX': 0,
  '5XX': 0,
}

setInterval(
  () => {
    const latency = getRandomInt(30) / 10;
    latencyBuckets['+Inf'] += 1;
    if (latency <= 2.0) {
      latencyBuckets['2.0'] += 1;
    }
    if (latency <= 1.5) {
      latencyBuckets['1.5'] += 1;
    }
    if (latency <= 1.0) {
      latencyBuckets['1.0'] += 1;
    }
    if (latency <= 0.5) {
      latencyBuckets['0.5'] += 1;
    }
    const response = getRandomInt(11);
    if (response <= 1) {
      responseCounts['5XX'] += 1;
    }
    if (response > 1 && response <= 4) {
      responseCounts['4XX'] += 1;
    }
    if (response > 4) {
      responseCounts['2XX'] +=1;
    }
  },
  1000,
)

function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

function metricToString(name, tags, value) {
  const tagsString = Object
    .entries(tags)
    .map(([name, value]) => `${name}="${value}"`)
    .join(',');

  return `${name}{${tagsString}} ${value}`;
}

const server = http.createServer((req, res) => {
  const isUpMetrics = Object
    .entries(
      {
        app1: getRandomInt(2) < 1,
        app2: getRandomInt(2) < 1,
        app3: getRandomInt(2) < 1,
        app4: getRandomInt(2) < 1,
      }
    )
    .map(([name,value]) => metricToString(
      'up',
      {application: name, environment: 'e1', datacenter: 'd1'},
      value ? '1.0' : '0.0'
    ))
    .join('\n');

  const latencyMetrics = Object
    .entries(latencyBuckets)
    .map(([name, value]) => metricToString(
      'z_application_latency_seconds_bucket',
      {le: name},
      `${value}`
    ))
    .join('\n');

  const responseMetrics = Object
    .entries(responseCounts)
    .map(([name, value]) => metricToString(
      'response_count',
      {status: name},
      `${value}`
    ))
    .join('\n');

  res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });

  res.end([isUpMetrics, latencyMetrics, responseMetrics].join('\n'));
});

server.listen(8080);

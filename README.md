# Example for statsd/graphite monitoring toolset

### Purpose of this sample environment
There are three Vagrant VMs, each fulfilling a different part of the monitoring environment.
The general flow:
* the metrics-sender VM has a small web service that reports a count statistic to statsd.  
* the statsd VM is called collector.  It receives the UDP traffic from the web service and aggregates it before sending it to graphite via TCP.
* graphite receives the stats, saving to a database and presents a graphical view of the stats.


### Seeing it in action
1. vagrant up:
  ```bash
  cd collector
  vagrant up

  cd ../graphite
  vagrant up

  cd ../metrics-sender
  vagrant up
  ```

2. provide a load:
  ``` bash
  cd .. #go back to root of project
  ./boom -n 1000 -q 5 http://localhost:9999 # send 1000 requests at 5/s
  ```

3. See the results in graphite.  Open [localhost:8080](localhost:8080), open (path to be filled in)

### How it works
1. Every time the endpoint is hit, the metrics-sender web service sends a count increment to statsd.
2. statsd aggregates the statistics and flushes it to graphite for storage.
3. graphite receives, stores and makes the stats available via the web interface, as well as a JSON format.

#### Collect metrics
[statsd aggregator](https://github.com/etsy/statsd/) collects and aggregates metrics from many sources/instances and publishes them to another backend, such as graphite.

[graphite](http://graphite.readthedocs.org/en/latest/) collects metrics, stores and displays them.

#### Display metrics
Graphite web interface: can make and save graphs.

#### Send metrics from a source
Bash: requires statsd and graphite VMs up and running.  This command sends the stat format statsd accepts:

```bash
echo "foo:1|c" | nc -u -w0 192.168.33.20 8125
```

Web service: send stats from a simple program, using, [statsd client for Go](https://github.com/cactus/go-statsd-client):

```bash
GOOS=linux go build -o hello
```

#### Load generation
[boom](https://github.com/rakyll/boom) can generate load.

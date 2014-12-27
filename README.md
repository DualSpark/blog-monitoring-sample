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
  vagrant up
  ```

2. provide a load:
  ``` bash
  vagrant ssh goapp
  ./boom -n 1000 -q 5 http://localhost:9999 # send 1000 requests at 5/s
  ```

3. See the results in graphite.  Open [graphite.vagrant.dev](http://graphite.vagrant.dev), open Graphite->stats->test-client->stat1 to see the graph.  If the above boom command was run, it should report a load at five (requests a second).  This image shows the 5 req/s boom command followed by a 25/s command:

[Graphite screenshot](graphite-screen.png?raw=true)


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
echo "foo:1|c" | nc -u -w0 statsd.vagrant.dev 8125
```

Web service: send stats from a simple program, using, [statsd client for Go](https://github.com/cactus/go-statsd-client).  The included executable is compiled for Linux so it runs in the Vagrant Linux VM.  If you're on a Mac you can install the Go tools and cross-compile for linux:

```bash
GOOS=linux go build -o main
```

#### Load generation
[boom](https://github.com/rakyll/boom) can generate load.  It's included in the goapp Vagrant VM.  Log in to the goapp VM and run it:

```bash
vagrant ssh goapp
./boom -n 100 -q 5 http://localhost:9999/
```

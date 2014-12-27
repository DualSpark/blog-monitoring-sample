# Example for statsd/graphite monitoring toolset

### Purpose of this sample environment
Show an end to end example of stats generation through graphing of results.

### High level view
There are three Vagrant VMs, each fulfilling a different part of the monitoring environment.
The general flow:
* the metrics-sender VM has a small web service that reports a "count" statistic to statsd.  
* the statsd VM is called collector.  It receives traffic and aggregates it before sending it to graphite.
* graphite receives the stats, saving them and presenting a graphical view.


### Seeing it in action
1. Install the vagrant [landrush plugin](https://github.com/phinze/landrush):
  ```bash
  vagrant plugin install landrush
  ```
  This allows guests and the host to use DNS names instead of IP addresses.

2. Bring the machines up:
  ```bash
  vagrant up
  ```

3. Provide a load.  [boom](https://github.com/rakyll/boom) is included in the goapp VM:
  ``` bash
  vagrant ssh goapp
  ./boom -n 1000 -q 5 http://localhost:9999 # send 1000 requests at 5/s
  ```

4. See the results in graphite.  Open [graphite.vagrant.dev](http://graphite.vagrant.dev), open Graphite->stats->test-client->stat1 to see the graph.  If the above boom command was run, it should report a load at five (requests a second).  This image shows the 5 req/s boom command followed by a 25/s command:

[Graphite screenshot](graphite-screen.png?raw=true)

# More detail (optional reading)
### How it works
1. Every time the Go web service's endpoint is hit, it sends a count increment to statsd.
2. statsd aggregates the statistics and flushes it to graphite for storage.
3. graphite receives, stores and makes the stats available via the web interface, as well as a JSON format.

#### Send metrics from a source
Bash: requires statsd and graphite VMs up and running.  This command sends the stat format statsd accepts:

```bash
echo "foo:1|c" | nc -u -w0 statsd.vagrant.dev 8125
```

Web service: send stats from a simple program, using, [statsd client for Go](https://github.com/cactus/go-statsd-client).  The included executable is compiled for Linux so it runs in the Vagrant Linux VM.  If you're on a Mac you can install the Go tools and cross-compile for linux:

```bash
GOOS=linux go build -o main
```

#### Collect/aggregate metrics
[statsd aggregator](https://github.com/etsy/statsd/) collects and aggregates metrics from many sources/instances and publishes them to another backend, such as graphite.

[graphite](http://graphite.readthedocs.org/en/latest/) collects metrics, stores and displays them.

#### Display metrics
The graphite web interface can make and save graphs.  There's also a [URL API](http://graphite.readthedocs.org/en/1.0/url-api.html) where the raw values can be exposed in various formats such as JSON.  A useful tool to put on top of graphite is [grafana](http://grafana.org/docs/).  It provides more options for graphing data.

#### Load generation
[boom](https://github.com/rakyll/boom) is included in the goapp Vagrant VM.  Log in to the goapp VM and run it:

```bash
vagrant ssh goapp
./boom -n 100 -q 5 http://localhost:9999/
```

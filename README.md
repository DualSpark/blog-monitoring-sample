# Example for statsd/graphite monitoring toolset

### Collect metrics
[statsd aggregator](https://github.com/etsy/statsd/) collects and aggregates metrics from many sources/instances and publishes them to another backend, such as graphite.

[graphite](http://graphite.readthedocs.org/en/latest/) collects metrics, stores and displays them.

### Display metrics
Graphite web interface: can make and save graphs.

### Send metrics
Bash, requires statsd and graphite VMs up and running:

```bash
echo "foo:1|c" | nc -u -w0 192.168.33.20 8125
```
[statsd client for Go](https://github.com/cactus/go-statsd-client)

### Load generation
[boom](https://github.com/rakyll/boom) to generate load.

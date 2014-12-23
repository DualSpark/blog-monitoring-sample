# Example for statsd/graphite monitoring toolset

### Collect metrics
statsd aggregator

graphite

### Display metrics
graphite web interface

### Send metrics
Bash, requires statsd and graphite VMs up and running:

```bash
echo "foo:1|c" | nc -u -w0 192.168.33.20 8125
```
statsd client

### Sample load
boom to generate load

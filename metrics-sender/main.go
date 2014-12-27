package main

import (
	"fmt"
	"github.com/cactus/go-statsd-client/statsd"
	"github.com/kelseyhightower/envconfig"
	"log"
	"net/http"
)

type Specification struct {
	StatsdUrl string // to set: export GOAPP_STATSDURL="urlhere:port"
}

var client *statsd.Client
var s Specification

func main() {
	err := setup()
	if err != nil {
		log.Fatal("Failed setup: ", err)
	}
	defer client.Close()

	http.HandleFunc("/", handler)            // redirect all urls to the handler function
	http.ListenAndServe("0.0.0.0:9999", nil) // listen for connections at port 9999 on the local machine

	log.Print("heading out")
}

func setup() error {
	log.Print("starting up")

	err := envconfig.Process("goapp", &s)
	if err != nil {
		log.Fatal(err.Error())
	}

	if s.StatsdUrl == "" {
		log.Print("No statsd url provided, defaulting to statsd.vagrant.dev:8125")
		s.StatsdUrl = "statsd.vagrant.dev:8125"
	}
	client, err = statsd.New(s.StatsdUrl, "test-client")
	if err != nil {
		log.Fatal(err)
	}
	return nil
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello world!")
	client.Inc("stat1", 1, 1.0)
}

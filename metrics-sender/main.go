package main

import (
	"fmt"
	"github.com/cactus/go-statsd-client/statsd"
	"github.com/kelseyhightower/envconfig"
	"log"
	"net/http"
)

var client *statsd.Client

type Specification struct {
	StatsdUrl string
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello world!")
	client.Inc("stat1", 1, 1.0)
}

func main() {
	log.Print("starting up")
	var err error

	var s Specification
	err = envconfig.Process("goapp", &s)
	if err != nil {
		log.Fatal(err.Error())
	}

	if s.StatsdUrl == "" {
		s.StatsdUrl = "statsd.vagrant.dev:8125"
	}
	// Change this to use environment configs and provide statsd.vagrant.dev as default
	client, err = statsd.New(s.StatsdUrl, "test-client")
	if err != nil {
		log.Fatal(err)
	}
	defer client.Close()

	http.HandleFunc("/", handler)            // redirect all urls to the handler function
	http.ListenAndServe("0.0.0.0:9999", nil) // listen for connections at port 9999 on the local machine

	log.Print("heading out")
}

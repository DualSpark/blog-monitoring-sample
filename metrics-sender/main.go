package main

import (
	"fmt"
	"github.com/cactus/go-statsd-client/statsd"
	"log"
	"net/http"
)

var client *statsd.Client

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello world!")
	client.Inc("stat1", 1, 1.0)
}

func main() {
	log.Print("starting up")
	var err error
	// Change this to use environment configs and provide statsd.vagrant.dev as default
	client, err = statsd.New("statsd.vagrant.dev:8125", "test-client")
	// handle any errors
	if err != nil {
		log.Fatal(err)
	}
	// make sure to clean up
	defer client.Close()

	http.HandleFunc("/", handler)            // redirect all urls to the handler function
	http.ListenAndServe("0.0.0.0:9999", nil) // listen for connections at port 9999 on the local machine

	log.Print("heading out")
}

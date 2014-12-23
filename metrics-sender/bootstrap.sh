#!/usr/bin/env bash

# put the startup script in place
sudo cp /home/vagrant/golang-app.conf /etc/init/golang-app.conf

sudo start golang-app

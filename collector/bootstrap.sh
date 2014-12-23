#!/usr/bin/env bash

# install node.js
#sudo apt-get update #commented out for faster test provisioning
sudo apt-get install -y nodejs

# put the startup script in place
sudo cp /home/vagrant/nodejs.conf /etc/init/nodejs.conf

# install statsd
cd /home/vagrant
wget https://github.com/etsy/statsd/archive/v0.7.2.tar.gz
tar -xvf v0.7.2.tar.gz

sudo start nodejs

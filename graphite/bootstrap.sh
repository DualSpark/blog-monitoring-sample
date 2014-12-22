#!/usr/bin/env bash

# from https://gist.github.com/jgeurts/3112065

cd /home/vagrant
wget https://launchpad.net/graphite/0.9/0.9.10/+download/graphite-web-0.9.10.tar.gz
wget https://launchpad.net/graphite/0.9/0.9.10/+download/carbon-0.9.10.tar.gz
wget https://launchpad.net/graphite/0.9/0.9.10/+download/whisper-0.9.10.tar.gz
tar -zxvf graphite-web-0.9.10.tar.gz
tar -zxvf carbon-0.9.10.tar.gz
tar -zxvf whisper-0.9.10.tar.gz
mv graphite-web-0.9.10 graphite
mv carbon-0.9.10 carbon
mv whisper-0.9.10 whisper
rm graphite-web-0.9.10.tar.gz
rm carbon-0.9.10.tar.gz
rm whisper-0.9.10.tar.gz

cd whisper
sudo python setup.py install 
cd ..

cd carbon
sudo python setup.py install
cd /opt/graphite/conf
sudo cp carbon.conf.example carbon.conf
#sudo cp storage-schemas.conf.example storage-schemas.conf # needed since we overwrite it?
echo -e "[stats] \npriority = 110\npattern = .*\nretentions = 10:2160,60:10080,600:262974" | sudo tee storage-schemas.conf

cd /home/vagrant/graphite
sudo apt-get install -y libapache2-mod-wsgi build-essential python-dev python-pip apache2 python-cairo python-memcache
sudo pip install 'django<1.6'
sudo pip install python-django-tagging
sudo pip install Twisted==13.0 # daemonize error
sudo python check-dependencies.py
sudo python setup.py install

# https://www.digitalocean.com/community/tutorials/installing-and-configuring-graphite-and-statsd-on-an-ubuntu-12-04-vps
sudo cp /home/vagrant/graphite/examples/example-graphite-vhost.conf /etc/apache2/sites-available/000-default.conf
sudo cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
sudo chown -R www-data:www-data /opt/graphite/storage
sudo mkdir -p /etc/httpd/wsgi
# edit /etc/apache2/sites-available/default
sudo sed -i -e "s/WSGISocketPrefix run\/wsgi/WSGISocketPrefix \/etc\/httpd\/wsgi/g" /etc/apache2/sites-available/000-default.conf
echo -e "SECRET_KEY = 'foobar555'\n ALLOWED_HOSTS = ['localhost']" | sudo tee >> /opt/graphite/webapp/graphite/settings.py

# sed this in settings.py:
# DATABASE_NAME = '/opt/graphite/storage/graphite.db'

sudo service apache2 restart

sudo /opt/graphite/bin/carbon-cache.py start


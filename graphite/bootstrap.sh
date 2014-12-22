#!/usr/bin/env bash

# from https://gist.github.com/jgeurts/3112065

sudo apt-get install -y libapache2-mod-wsgi build-essential python-dev python-pip apache2 python-cairo python-memcache
sudo pip install 'django<1.6'
sudo pip install django-tagging
sudo pip install Twisted==13.0 # daemonize error

# http://graphite.readthedocs.org/en/latest/install-pip.html
sudo pip install https://github.com/graphite-project/ceres/tarball/master
sudo pip install whisper
sudo pip install carbon
sudo pip install graphite-web

sudo cp /opt/graphite/webapp/graphite/local_settings.py.example /opt/graphite/webapp/graphite/local_settings.py

echo -e "SECRET_KEY = 'UNSAFE_DEFAULT_foo'\nALLOWED_HOSTS = [ '*' ]\nTIME_ZONE = 'America/Los_Angeles'\nDEBUG = True\n" | sudo tee --append /opt/graphite/webapp/graphite/local_settings.py

# overwrite stock apache site:
sudo cp /opt/graphite/examples/example-graphite-vhost.conf /etc/apache2/sites-available/000-default.conf

sudo cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi

sudo sed -i -e "s/WSGISocketPrefix run\/wsgi/WSGISocketPrefix \/var\/run\/apache2\/wsgi/g" /etc/apache2/sites-enabled/000-default.conf
sudo chown -R www-data:www-data /opt/graphite/

# sketchy permission change:
sudo sed -i -e "s/Require all denied/Require all granted/g" /etc/apache2/apache2.conf

sudo /etc/init.d/apache2 reload
cd /opt/graphite/webapp/graphite
sudo python manage.py syncdb --noinput
sudo chown -R www-data:www-data /opt/graphite/ # get the new database file

sudo cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf
sudo cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf

sudo /opt/graphite/bin/carbon-cache.py start

# sample data points: 
echo "local.random.diceroll 6 `date +%s`" | nc -q0 localhost 2003
echo "local.random.diceroll 3 `date +%s`" | nc -q0 localhost 2003

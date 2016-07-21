#!/usr/bin/env bash

echo "Updating"
sudo apt-get update

echo "Installing"
sudo apt-get install -y curl postgresql git

echo "Postgres Setup"
sudo -u postgres bash -c "psql -c \"CREATE USER vagrant WITH PASSWORD 'vagrant';\""
sudo -u postgres bash -c "createdb expense_tracker"
sudo -u postgres bash -c "createdb expense_tracker_test"

echo "Go Setup"
cd ~
sudo curl -s -O https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
sudo tar -xvf go1.6.linux-amd64.tar.gz
sudo mv go /usr/local
sudo rm go1.6.linux-amd64.tar.gz

echo "export PATH=$PATH:/usr/local/go/bin:/home/vagrant/go/bin" >> /home/vagrant/.profile

sudo mkdir /home/vagrant/go
echo "export GOPATH=/home/vagrant/go" >> /home/vagrant/.profile

source /home/vagrant/.profile

echo "Server Project Setup"
cd /home/vagrant/go/src/github.com/LastZactionHero/expense_tracker
go get ./...
go build && go install

sudo chown -R vagrant /home/vagrant/go
sudo chgrp -R vagrant /home/vagrant/go

echo "export EXPENSE_TRACKER_DB_HOST=localhost"       >> /home/vagrant/.profile
echo "export EXPENSE_TRACKER_DB_USER=vagrant"         >> /home/vagrant/.profile
echo "export EXPENSE_TRACKER_DB_NAME=expense_tracker" >> /home/vagrant/.profile
echo "export EXPENSE_TRACKER_DB_PASS=vagrant"         >> /home/vagrant/.profile
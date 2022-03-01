#!/bin/bash
echo "bootstrapping vpn Server with Pritunl"
sudo apt update
echo "deb http://repo.pritunl.com/stable/apt bionic main" | sudo tee /etc/apt/sources.list.d/pritunl.list
sudo touch /etc/apt/sources.list.d/mongodb-org-4.0.list
echo "deb https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" >> /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt update
sudo apt --assume-yes install pritunl mongodb-server
sudo systemctl start pritunl mongodb
sudo systemctl enable pritunl mongodb

#Stop Pritunl
sudo systemctl Stop pritunl mongodb
sleep 10

#Set path for MongoDB:
echo "Set path for MongoDB..."
sudo pritunl set-mongodb mongodb://localhost:27017/pritunl

sudo systemctl start pritunl mongodb
#!/bin/bash
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb http://repo.pritunl.com/stable/apt focal main
EOF
# Import signing key from keyserver
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
# Alternative import from download if keyserver offline
curl https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | sudo apt-key add -
sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list << EOF
deb https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse
EOF
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo ufw disable
sudo apt update
sudo apt -y install \
    wireguard \
    wireguard-tools\
    unzip \
    pritunl \
    mongodb-org

unzip awscliv2.zip
sudo ./aws/install
sudo systemctl stop pritunl mongodb
sleep 10
sudo pritunl set-mongodb mongodb://localhost:27017/pritunl
sudo systemctl enable mongod pritunl
sudo systemctl start mongod pritunl
sudo systemctl start pritunl mongodb

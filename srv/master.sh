#!/bin/bash
# setup salt master
# usage:
# wget https://raw.githubusercontent.com/immonju1/salt/master/master.sh
# chmod g+x master.sh
# sudo ./master.sh

setxkbmap fi
echo "Updating packages and install salt and git..."
apt-get update -qq >> /dev/null
apt-get install git salt-master -y -qq >> /dev/null

# Create directories
if [ ! -d "/srv/" ]; then
mkdir /srv/
fi

echo "Cloning Git..."
# change rest of code accordingly, code is copied from my another project

cd /srv

git clone https://github.com/immonju1/salt.git

cd /srv/salt/users/

git clone https://github.com/immonju1/flask-crud.git

mv flask-crud public_wsgi

# Collect developer user details
echo
echo "Collecting password..."
echo "Enter password for development user:"
stty -echo
read pass
stty echo

if [ ! -d "/srv/pillar" ]; then
mkdir /srv/pillar
fi

# Write details into pillar
echo -n "pw: " > /srv/salt/srvpillar/server.sls

openssl passwd -1 $pass  >> /srv/salt/srvpillar/server.sls

echo "Copying pillars..."
cp -R /srv/salt/srvpillar/* /srv/pillar





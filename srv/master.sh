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

git clone https://github.com/niinavi/Jarjestelmaprojekti.git

echo "Copying salt states..."
cp -R Jarjestelmaprojekti/srv/salt/* /srv/salt





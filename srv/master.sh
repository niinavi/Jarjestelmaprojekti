#!/bin/bash
# setup salt master
# usage:
# wget https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/srv/master.sh
# chmod g+x master.sh
# sudo ./master.sh

setxkbmap fi
echo "Updating packages and install salt and git..."
apt-get update -qq >> /dev/null
apt-get install git apache2-utils salt-master -y -qq >> /dev/null

# Create directories
if [ ! -d "/srv/" ]; then
mkdir /srv/
fi

echo "Cloning Git..."

git clone https://github.com/niinavi/Jarjestelmaprojekti.git

echo "Copying salt states..."
mkdir /srv/salt
cp -R Jarjestelmaprojekti/srv/salt/* /srv/salt





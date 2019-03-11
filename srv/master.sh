#!/bin/bash
# setup salt master
# usage:
# wget https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/srv/master.sh
# chmod g+x master.sh
# sudo ./master.sh

setxkbmap fi
echo "Updating packages and install salt and git..."
apt-get update -qq >> /dev/null
apt-get install git apache2-utils salt-master salt-minion -y -qq >> /dev/null

# Create directories
if [ ! -d "/srv/" ]; then
mkdir /srv/
fi

if [ ! -d "/srv/pillar" ]; then
mkdir /srv/pillar
fi

if [ ! -d "/srv/salt" ]; then
mkdir /srv/salt
fi

echo -e "master: localhost\nid: master" | sudo tee /etc/salt/minion

echo "Cloning Git..."

git clone https://github.com/niinavi/Jarjestelmaprojekti.git

echo "Enter password for Kibana user:"
stty -echo
read pass
stty echo

# Write details into pillar
echo -n "pw: " > Jarjestelmaprojekti/srv/srvpillar/server.sls
echo $pass  >> Jarjestelmaprojekti/srv/srvpillar/server.sls

echo -n "ip: " > Jarjestelmaprojekti/srv/srvpillar/filebeat.sls
hostname -I >> Jarjestelmaprojekti/srv/srvpillar/filebeat.sls

echo "Copying pillars..."
cp -R Jarjestelmaprojekti/srv/srvpillar/* /srv/pillar

echo "Copying salt states..."
cp -R Jarjestelmaprojekti/srv/salt/* /srv/salt

systemctl restart salt-minion





#!/bin/bash
# salt minion installation
# https://raw.githubusercontent.com/niinavi/Jarjestelmaprojekti/master/srv/minion.sh
# chmod g+x minion.sh
# sudo ./minion.sh
# IP is local laptop IP. Should be changed accordingly

apt-get update
apt-get install salt-minion -y 

echo "Please enter master IP address here:"
read MasterIP
echo "Please enter a unique id for your system:"
read SystemID
echo "Writing salt settings to file and restarting salt-minion..."
echo -e "master: $MasterIP\nid: $SystemID" | sudo tee /etc/salt/minion

#echo -e 'master: 10.0.2.2\nid: vagminion'|sudo tee /etc/salt/minion
systemctl restart salt-minion
 


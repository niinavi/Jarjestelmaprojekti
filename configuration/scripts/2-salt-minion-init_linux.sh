#!/bin/env bash

###########################################################

SALTMASTER_IPv4="10.10.1.2"
MINION_ID=$(hostname)

SALT_CONF="/etc/salt/minion"

# Install Salt minion from default Ubuntu repositories
# If not true, then use official SaltStack repositories
# (these may include newer SaltStack version)
#
SALT_DISTROREPO="true"

###########################################################
# Allow interruption of the script at any time (Ctrl + C)
trap "exit" INT

###########################################################
# Check if we're using bash or sh to run the script.
# If bash, OK. If sh, ask user to run the script with bash.

BASH_CHECK=$(ps | grep `echo $$` | awk '{ print $4 }')
if [ $BASH_CHECK != "bash" ]; then
    echo  "
Please run this script using bash (/usr/bin/bash).
    "
    exit 1
fi

###########################################################
# Check if our UID (user ID) is 0 or not

if [ $(id -u) -ne 0 ]; then
  echo "Run the script with root permissions (sudo or root)."
  exit 1
fi

###########################################################
# Check Salt master Linux distribution

if [[ -f /etc/os-release ]]; then
  MASTER_DISTRO=$(grep ^VERSION_ID /etc/os-release | grep -oP '(?<=")[^"]*')

  if [[ $MASTER_DISTRO != "18.04" ]]; then
    echo -e "This script is supported only on Ubuntu 18.04 LTS. Aborting.\n"
    exit 1
  fi
  
else
  echo -e "Can't recognize your Linux distribution. Aborting.\n"
  exit 1
fi

###########################################################
function checkInternet() {
  if [[ $(echo $(wget --delete-after -q -T 5 ${1} -o -)$?) -ne 0 ]]; then
    echo -e "\nInternet connection failed (${2}). Please check your connection and try again.\n"
    exit 1
  fi
}

checkInternet "github.com" "GitHub"

###########################################################
# Welcome message

function welcomeMessage() {
  echo -e "This script will set up Salt minion environment on this computer.\n"
  read -r -p "Continue? [y/N] " answer
  if [[ ! $(echo $answer | sed 's/ //g') =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "Aborting.\n"
    exit 1
  fi
  unset answer
}

welcomeMessage

###########################################################

echo -e "Salt Minion: Installing minion service\n"

# Install Salt Minion
if [[ $SALT_DISTROREPO == "true" ]]; then
  apt update && sudo apt -y install salt-minion
else
  wget -O - https://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
  echo "deb http://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest bionic main" > /etc/apt/sources.list.d/saltstack.list
  apt-get update && apt -y install salt-minion
fi

echo -e "Salt Minion: configuring minion service\n"

# Stop Salt minion service if active
if [[ $(systemctl is-active salt-minion) == "active" ]]; then
  systemctl stop salt-minion
fi

# Create dir path /etc/salt if doesn't exist
if [[ ! -d /etc/salt ]]; then
  mkdir -p /etc/salt
  if [[ $? -ne 0 ]]; then
  	echo -e "Salt Minion: couldn't create directory /etc/salt. Aborting"
    exit 1
  fi
fi

# Supply necessary Salt minion information
cat <<MINION_CONF > ${SALT_CONF}
master: "${SALTMASTER_IPv4}"
id: ${MINION_ID}
MINION_CONF

echo -e "Salt Minion: Auto-start minion service during boot-up\n"

# Start and enable Salt minion service (boot)
systemctl start salt-minion
systemctl enable salt-minion

# etc...
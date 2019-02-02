#!/bin/env bash

# ELK server initialization script

# Sets up SaltStack environment

# Phase 1

#	- Install Salt Master
#	- Deploy Salt Master filesystem folders
#   - Deploy Salt Master SaltStack state files (sls)
#   - Run Salt Master configuration
#   - Download necessary installation files (Winlogbeat)
#   - Retrieve Salt Minion information, accept recognized minions
#   - Run minion configuration

# Phase 2

#   - Test Kibana web view (options: xdg-open http://localhost:5601 (Direct connect) | xdg-open http://localhost:80 (via Apache proxy))
#   - Test test-server_2 Apache web view (options: xdg-open http://10.10.1.30:80 (Direct connect) | xdg-open http://localhost:80/<sitename> (via Apache proxy))

# etc...
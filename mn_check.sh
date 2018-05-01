Exvo#!/bin/bash
# EXVO Masternode Setup Script V1.2 for Ubuntu 16.04 LTS
# (c) 2018 by Allroad [FasterPool.com] for Exvo

#Color codes
RED='\033[0;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#Exvo TCP port
PORT=8585

#Clear keyboard input buffer
function clear_stdin { while read -r -t 0; do read -r; done; }

#Delay script execution
function delay { echo -e "${GREEN}Sleep for $1 seconds...${NC}"; sleep "$1"; }

clear

cd /root/exvo/src/

publicip=''
publicip=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo -e "${YELLOW}IP Address:" $publicip ${NC}

echo -e "${GREEN}Masternode Get Info${NC}"
./exvo-cli getinfo
delay 2

global_mn_count=$(./exvo-cli masternode count)
echo -e "Global Masternode Num:${GREEN}$global_mn_count ${NC}"
delay 2

mn_status=$(./exvo-cli masternode list | grep $publicip)
echo -e "${GREEN}Our MN Status: $mn_status ${NC}"
delay 2

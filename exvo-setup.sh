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
echo -e "${YELLOW}Exvo Masternode Setup Script for Ubuntu 16.04 LTS${NC}"
echo -e "${GREEN}Updating system and installing required packages...${NC}"
sudo apt-get update -y

# Install dnsutils if necessary
dpkg -s dnsutils 2>/dev/null >/dev/null || sudo apt-get -y install dnsutils

publicip=''
publicip=$(dig +short myip.opendns.com @resolver1.opendns.com)

if [ -n $publicip ]; then
    echo -e "${YELLOW}IP Address detected:" $publicip ${NC}
else
    echo -e "${RED}ERROR:${NC} Public IP Address was not detected! \a"
    clear_stdin
    read -e -p "Enter VPS Public IP Address: " publicip
fi

read -t 1 -n 10000 discard
read -e -p "Masternode Private Key (e.g. 28L11p9KSUQMyw5z6QYay8q68WnNxuH5BbeyAhWutwav1TSNC4S # THE KEY YOU GENERATED EARLIER) : " key


# update packages and upgrade Ubuntu
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y install wget nano htop jq
sudo apt-get -y install libzmq3-dev
sudo apt-get -y install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get -y install libevent-dev

sudo apt -y install software-properties-common
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get -y update
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev

sudo apt-get -y install libminiupnpc-dev

sudo apt-get -y install fail2ban
sudo service fail2ban restart

sudo apt-get install ufw -y
sudo apt-get update -y

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow $PORT/tcp
echo -e "${YELLOW}"
sudo ufw --force enable
echo -e "${NC}"

#Generating Random Password for exvod JSON RPC
rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

#Create 2GB swap file
if grep -q "SwapTotal" /proc/meminfo; then
    echo -e "${GREEN}Swap is already configured${NC}"
else
    echo -e "${YELLOW}Creating 2GB disk swap file. \nThis may take a few minutes!${NC} \a"
    touch /var/swap.img
    chmod 600 swap.img
    dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
    mkswap /var/swap.img 2> /dev/null
    swapon /var/swap.img 2> /dev/null
    if [ $? -eq 0 ]; then
        echo '/var/swap.img none swap sw 0 0' >> /etc/fstab
        echo -e "${GREEN}Swap was created successfully!${NC}"
    else
        echo -e "${YELLOW}Operation not permitted! Optional swap was not created.${NC} \a"
        rm /var/swap.img
    fi
fi

#Installing Daemon

sudo mkdir -p /root/exvo/src
tar zxvf Exvo-Ubuntu16.04.tar.gz
sudo cp Exvo-Ubuntu16.04/exvo* /root/exvo/src/
sudo chmod 755 -R /root/ExvoMasternodeSetup
sudo chmod 755 /root/exvo/src/exvo*

echo -e "${GREEN} Complete Copy Files To /root/exvo/src/${NC}"

#Starting daemon first time
cd /root/exvo/src/
./exvod -daemon
delay 5
echo -e "${GREEN}Exvod Started${NC}"

killall exvod
delay 5
echo -e "${GREEN}Exvod Killed${NC}"

cat <<EOF > ~/.exvo/exvo.conf
rpcuser=
rpcpassword=
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
maxconnections=256
masternode=1
promode=1
externalip=$publicip:8585
masternodeprivkey=$key
EOF

echo -e "${GREEN}Complete exvo.conf Configuration ${NC}"

#Starting daemon second time
cd /root/exvo/src/
./exvod -daemon
delay 5

echo -e "${GREEN}Test Masternode Installation${NC}"
./exvo-cli getinfo
delay 300

./exvo-cli masternode start
echo -e "${GREEN}Complete Masternode Start${NC}"
delay 10

global_mn_count=$(./exvo-cli masternode count)
echo -e "Global Masternode Num:${GREEN}$global_mn_count ${NC}"
delay 5

mn_status=$(./exvo-cli masternode list | grep $publicip)
echo -e "${GREEN}Our MN Status: $mn_status ${NC}"
delay 5

#!/bin/bash

#Check and wait for connection
while ! ping -c 1 -W 1 google.com; do
    echo "Waiting for Internet connection - network interface might be down..."
    sleep 1
done

#Check for wget
if ! which wget > /dev/null; then
   echo -e "Command not found! Install? (y/n) \c"
   read
   if "$REPLY" = "y"; then
      sudo apt-get install wget -y
   fi
fi

#Fetch Golang
wget https://golang.org/dl/go1.16.3.linux-armv6l.tar.gz

#install go
echo "Installing go ..."
sudo tar --overwrite -C /usr/local -xzf go1.16.3.linux-armv6l.tar.gz

#Add go to PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/$USER/.bashrc

#Reloading bashrc
source /home/$USER/.bashrc
export PATH=$PATH:/usr/local/go/bin
#Testing go
go version

#check for git
if ! which git > /dev/null; then
   echo -e "Command not found! Install? (y/n) \c"
   read
   if "$REPLY" = "y"; then
      sudo apt-get install git -y
   fi
fi

#clone probe-cli
echo "Fetching probe-cli.git"
mkdir -p /home/$USER/opt/ooniprobe
git clone https://github.com/ooni/probe-cli.git /home/$USER/opt/ooniprobe
#build ooniprobe
echo "bulding ooniprobe, this will take some time, grab a coffee ..."
cd /home/$user/opt/ooniprobe && go build -ldflags='-s -w' -v ./cmd/ooniprobe

echo "if everything went fine you should find the binary in /home/$USER/opt/ooniprobe root dir, run it with ./ooniprobe"

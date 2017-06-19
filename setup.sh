#!/bin/bash

before_reboot(){
  node_id=0
  re='^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-5][0-4])$'
  while ! [[ $node_id =~ $re ]]
  do
    echo "What is the number of this node? [1-254]: "
    read node_id
  done
  
  
  cd /var/tmp
  
  echo "Enable autologin"
  sudo ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
  
  echo "Enable ssh"
  sudo systemctl enable ssh.socket
  
  echo "apt-get update"
  sudo apt-get update
  
  echo "Removing wpa suplicant"
  sudo apt-get remove -y wpasupplicant
  
  echo "Installing dependencies"
  sudo apt-get install -y bc libncurses5-dev git mercurial tcpdump tshark
  
  echo "Getting kernel headers"
  sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source && sudo chmod +x /usr/bin/rpi-source && /usr/bin/rpi-source -q --tag-update
  rpi-source
  
  echo "Installing WiFi drivers"
  git clone https://github.com/regisin/rtl8812au-1
  cd rtl8812au-1
  make
  sudo make install
  
  echo "Copying template files"
  cd /var/tmp
  wget https://raw.githubusercontent.com/regisin/testbed/master/templates/interfaces
  sudo cp /var/tmp/interfaces /etc/network/interfaces
  wget https://raw.githubusercontent.com/regisin/testbed/master/templates/keyboard
  sudo cp /var/tmp/keyboard /etc/default/keyboard
  
  echo "Renaming node, input required"
  wget https://raw.githubusercontent.com/regisin/testbed/master/name_this_node.py
  sudo python2.7 name_this_node.py --node-id $node_id
  
  echo "Removing files"
  cd ~
  rm linux-*.tar.gz
  cd /var/tmp
  sudo rm -rf rtl*
  sudo rm name_this_node.py
  sudo rm interfaces
  
  echo "Getting ns-3"
  cd ~
  git clone http://github.com/regisin/ns-3.26
  cd ns-3.26
  ./waf configure --enable-examples --enable-sudo
  ./waf
  
  echo "Removing myself"
  cd /var/tmp
  rm -- "$0"
}

before_reboot
echo "Rebooting to make effect"
sudo reboot

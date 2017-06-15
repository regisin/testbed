#!/bin/bash

before_reboot(){
  cd /var/tmp
  
  echo "Enable autologin"
  sudo ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
  
  echo "Enable ssh"
  sudo systemctl enable ssh.socket
  
  echo "Copying template files"
  cd /var/tmp
  wget https://raw.githubusercontent.com/regisin/testbed/master/templates/interfaces
  sudo cp /var/tmp/interfaces /etc/network/interfaces
  wget https://raw.githubusercontent.com/regisin/testbed/master/templates/rc.local
  sudo cp /var/tmp/rc.local /etc/rc.local
  wget https://raw.githubusercontent.com/regisin/testbed/master/templates/keyboard
  sudo cp /var/tmp/keyboard /etc/default/keyboard
  
  echo "Renaming node, input required"
  wget https://raw.githubusercontent.com/regisin/testbed/master/name_this_node.py
  sudo python2.7 name_this_node.py
  
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
  
  echo "Getting ns-3"
  cd ~
  hg clone http://code.nsnam.org/ns-3.26
  cd ns-3.26
  ./waf configure --enable-examples --enable-sudo
  ./waf --run="scratch-simulator"
  
  echo "Removing files"
  cd ~
  rm linux-*.tar.gz
  cd /var/tmp
  sudo rm -rf rtl*
  sudo rm name_this_node.py
  sudo rm interfaces
  sudo rm rc.local
  rm -- "$0"
}

before_reboot
echo "Rebooting to make effect"
sudo reboot

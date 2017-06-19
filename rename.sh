#!/bin/bash

before_reboot(){
  node_id=0
  re='^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-5][0-4])$'
  while ! [[ $node_id =~ $re ]]
  do
    echo "What is the number of this node? [1-254]: "
    read node_id
  done
  
  echo "Copying template files"
  cd /var/tmp
  wget https://raw.githubusercontent.com/regisin/testbed/master/templates/interfaces
  sudo cp /var/tmp/interfaces /etc/network/interfaces
  
  echo "Renaming node, input required"
  wget https://raw.githubusercontent.com/regisin/testbed/master/name_this_node.py
  sudo python2.7 name_this_node.py --node-id $node_id
  
  echo "Removing files"
  cd /var/tmp
  sudo rm name_this_node.py
  sudo rm interfaces
  
  echo "Removing myself"
  cd /var/tmp
  rm -- "$0"
}

before_reboot
echo "Rebooting to make effect"
sudo reboot

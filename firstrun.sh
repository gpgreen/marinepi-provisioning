#!/bin/bash
PUBLIC_KEY=~/.ssh/id_rsa.pub

if [[ "$1" =~ ^(-h|-\?|--help)$ ]] ; then
  echo -e "\nCopies SSH public key to the given Raspberry Pi host. \n"
  echo -e "Uses raspberrypi.local as host and the key in ~/.ssh/id_rsa.pub as default.\n"
  echo -e "Usage: $0 [<host> ssh-public-key-file]\n"
  exit 1
fi

HOST=raspberrypi.local
if [ "$1" != "" ]; then
  HOST=$1
fi

if [ "$2" != "" ]; then
  if [ ! -f "$2" ]; then
    echo "File not found: $2"
    exit 1
  else
    PUBLIC_KEY=$2
  fi
fi

if grep -q $HOST ~/.ssh/known_hosts; then
  echo -e "\nRemoving $HOST from ~/.ssh/known_hosts..\n\n"
  ssh-keygen -R $HOST
fi

export ANSIBLE_HOST_KEY_CHECKING=false

ansible-playbook -k -i $HOST, setup.yml -e "ssh_public_key=$PUBLIC_KEY" -e ansible_ssh_user=ggreen

#!/bin/bash
# set role path in ansible.cfg or ANSIBLE_ROLES_PATH environment variable
if [ "$#" -lt 3 ]; then
    echo -e "\nProvisions a host using a single role as the playbook\n"
    echo -e "Assumes that passwordless SSH is already setup for the host. (Use firstrun.sh for achieve that)\n"
    echo -e "Usage: $0 <user> <host> <role>\n"
    exit 1
fi

user=$1
host=$2
role=$3

shift 3

cat > /tmp/play.yml <<PLAYBOOK
---
- hosts: all
  remote_user: $user
  gather_facts: yes
  become: yes

  roles:
  - $role
PLAYBOOK

export ANSIBLE_ROLES_PATH=$(dirname $0)/roles

ansible-playbook /tmp/play.yml -i $host, $*

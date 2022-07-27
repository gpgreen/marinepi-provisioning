#!/bin/bash
# set role path in ansible.cfg or ANSIBLE_ROLES_PATH environment variable

user=$1
role=$2

shift 1

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

host=$1
shift 1

ansible-playbook /tmp/play.yml -i $host, $*

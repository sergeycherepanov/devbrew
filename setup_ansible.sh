#!/bin/bash
set -e
set -x
pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null
curl -L -o ${DIR}/portable-ansible.tar.bz2 https://github.com/ownport/portable-ansible/releases/download/v0.5.0/portable-ansible-v0.5.0-py3.tar.bz2
rm -rf ${DIR}/ansible
tar -jxf ${DIR}/portable-ansible.tar.bz2
rm ${DIR}/portable-ansible.tar.bz2

$(which python3) ansible-galaxy collection install community.general
$(which python3) ansible-galaxy collection install community.crypto
$(which python3) ansible-galaxy collection install community.docker
if [[ -d ./.ansible_library ]]; then
git add ./.ansible_library
fi
if [[ -d ./.ansible_collections ]]; then
git add ./.ansible_collections
fi
git add ansible


#!/bin/bash
pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null

MAC_USER=${SUDO_USER-${USER}}

sudo -u ${MAC_USER} xcode-select -p >/dev/null 2>&1 || {
  # Initialize script dir
  echo ""
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "!!!!! WARNING !!!!! Please finish XCODE installation before continue !!!!!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo ""
  xcode-select --install
}

ansible --version >/dev/null 2>&1 || {
  sudo sh -c "easy_install pip && pip install --ignore-installed --upgrade ansible"
}

ansible-playbook --ask-sudo-pass -i "localhost," -c local "$DIR/main.yml" -e "mac_user=${MAC_USER}" "$@"

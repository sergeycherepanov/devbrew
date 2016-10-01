#!/bin/bash
pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null

if [[ $(whoami) == "root" ]]; then
    echo "!!! Executing under root will destruct your system !!! Stopping..."
    exit 1
fi

xcode-select -p >/dev/null 2>&1 || {
  # Initialize script dir
  echo ""
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "!!!!! WARNING !!!!! Please finish XCODE installation before continue !!!!!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo ""
  xcode-select --install
}

ansible --version >/dev/null 2>&1 || {
  sudo easy_install pip
  sudo pip install --ignore-installed --upgrade ansible
}

ansible-playbook --ask-sudo-pass -i "localhost," -c local "$DIR/main.yml" $@

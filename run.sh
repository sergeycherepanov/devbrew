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

# Install ansible if not found or upgrade if outdated
ansible --version >/dev/null 2>&1 \
&& php -r "version_compare('"$(ansible --version  | head -1 | awk '{print $2}')"', '2.4.1', '>=') ? exit(0) : exit(1);" || {
  sudo sh -c "easy_install pip && pip install --ignore-installed --upgrade ansible"
}

sudo -u ${MAC_USER} ansible-playbook --ask-become-pass -i "localhost," -c local "$DIR/main.yml" -e "mac_user=${MAC_USER}" "$@"

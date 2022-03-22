#!/bin/bash
set -e
set -x
pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null
cd $DIR
git reset --hard
git clean -fd
git pull
export ANSIBLE_NOCOWS=1
MAC_USER=${SUDO_USER-${USER}}
MIN_PYTHON_VERSION_MACOS="2.7.15"
MIN_PYTHON_VERSION_LINUX="2.7.15"
PYTHON_PKG_LINUX="Python-${MIN_PYTHON_VERSION_LINUX}.tgz"
PYTHON_PKG_MACOS="python-${MIN_PYTHON_VERSION_MACOS}-macosx10.9.pkg"
PYTHON_BIN=${PYTHON_BIN:-$(which python > /dev/null && which python || true)}
PYTHON_BIN=${PYTHON_BIN:-$(which python3 > /dev/null && which python3 || echo "/usr/bin/python")}
ANSIBLE_PLAYBOOK_CMD="${PYTHON_BIN} ${DIR}/ansible-playbook"

if [[ $(id -u ${MAC_USER}) -eq 0 ]]; then
  echo "Please don't run this script under the root user!"
  exit 1
fi

if ! which brew; then
  echo "Homebrew not found!"
  exit 1
fi

hash -r

sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_CMD} --version
sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_CMD} -i "localhost," -c local "${DIR}/main.yml" --extra-vars="ansible_python_interpreter=${PYTHON_BIN}" -e "mac_user=${MAC_USER}" -e "brew_install_path=$(brew --prefix)" "$@"

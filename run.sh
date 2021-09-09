#!/bin/bash
set -x
git reset --hard
git clean -fd
git pull
pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null
export ANSIBLE_NOCOWS=1
MAC_USER=${SUDO_USER-${USER}}
MIN_PYTHON_VERSION_MACOS="2.7.15"
MIN_PYTHON_VERSION_LINUX="2.7.15"
PYTHON_PKG_LINUX="Python-${MIN_PYTHON_VERSION_LINUX}.tgz"
PYTHON_PKG_MACOS="python-${MIN_PYTHON_VERSION_MACOS}-macosx10.9.pkg"
PYTHON_BIN=${PYTHON_BIN-"/usr/bin/python"}
ANSIBLE_PLAYBOOK_CMD="${PYTHON_BIN} ${DIR}/ansible-playbook"

if [[ $(id -u ${MAC_USER}) -eq 0 ]]; then
  echo "Please don't run this script under the root user!"
  exit 1
fi

hash svnsync

if [[ "Darwin" == "$(uname)" ]]; then
  BREW_INSTALL_PATH="${BREW_INSTALL_PATH-/usr/local}"
else
  if [[ "Linux" == "$(uname)" ]]; then
    source /etc/os-release
    if [[ "debian" == "${ID}" ]] || [[ "debian" == "${ID_LIKE}" ]] || [[ "ubuntu" == "${ID_LIKE}" ]]; then
      sudo apt -qq update && sudo apt install -yqq iptables ca-certificates build-essential systemtap-sdt-dev curl file git python
      BREW_INSTALL_PATH="${BREW_INSTALL_PATH-/home/linuxbrew/.linuxbrew}"
    else
      echo "Unsupported system: '$(uname):${ID_LIKE}'"
      exit 1
    fi
  else
    echo "Unsupported system: '$(uname):${ID_LIKE}'"
    exit 1
  fi
fi
sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_CMD} --version
sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_CMD} -i "localhost," -c local "${DIR}/main.yml" --extra-vars="ansible_python_interpreter=$(which python)" -e "mac_user=${MAC_USER}" -e "brew_install_path=${BREW_INSTALL_PATH}" "$@"

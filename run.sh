#!/bin/bash
pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null

MAC_USER=${SUDO_USER-${USER}}
MIN_ANSIBLE_VERSION="2.4.4.0"
PYTHON_VERSION="2.7.15"
PYTHON_PKG_LINUX="Python-${PYTHON_VERSION}.tgz"
PYTHON_PKG_MACOS="python-${PYTHON_VERSION}-macosx10.9.pkg"

if [[ "Darwin" == "$(uname)" ]]; then
  # Install python if outdated
  if ! php -r "version_compare('"$(python --version 2>&1 | awk '{print $2}')"', '${PYTHON_VERSION}', '>=') ? exit(0) : exit(1);" || ! which pip > /dev/null; then
    curl -o "/tmp/${PYTHON_PKG_MACOS}" "https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_PKG_MACOS}"
    sudo installer -pkg "/tmp/${PYTHON_PKG_MACOS}" -target /
  fi
  cd $(dirname $(which python)); cd $(dirname $(readlink $(which python)))

  # Install Ansible if not found or upgrade if outdated
  ./ansible --version >/dev/null 2>&1 \
  && php -r "version_compare('"$(./ansible --version  | head -1 | awk '{print $2}')"', '${MIN_ANSIBLE_VERSION}', '>=') ? exit(0) : exit(1);" || {
    sudo -H ./pip install --force-reinstall --upgrade ansible
  }
  ANSIBLE_PLAYBOOK_BIN="./ansible-playbook"
else
  if [[ "Linux" == "$(uname)" ]]; then
    source /etc/os-release
    if [[ "debian" == "${ID_LIKE}" ]]; then
      if ! which python > /dev/null || dpkg --compare-versions "$(python --version 2>&1 | awk '{print $2}')" lt "${PYTHON_VERSION}"; then
        cd /tmp
        sudo apt install -yq curl git
        curl -o "/tmp/${PYTHON_PKG_LINUX}" "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"
        sudo tar xzf "${PYTHON_PKG_LINUX}"
        cd Python-2.7.15
        sudo ./configure --enable-optimizations
        sudo make
        sudo make install
      fi
      if ! which ansible > /dev/null || dpkg --compare-versions "$(ansible --version 2>&1 | head -n1 | awk '{print $2}')" lt "${MIN_ANSIBLE_VERSION}"; then
        sudo pip install --force-reinstall --upgrade ansible
      fi
      ANSIBLE_PLAYBOOK_BIN="$(which ansible-playbook)"
    else
      echo "Unsupported system: '$(uname):${ID_LIKE}'"
      exit 1
    fi
  else
    echo "Unsupported system: '$(uname):${ID_LIKE}'"
    exit 1
  fi
fi

sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_BIN} -i "localhost," -c local "${DIR}/main.yml" -e "mac_user=${MAC_USER}" "$@"

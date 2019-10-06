#!/bin/bash
set -x
pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null

MAC_USER=${SUDO_USER-${USER}}
MIN_ANSIBLE_VERSION="2.4.4.0"
MIN_PYTHON_VERSION_MACOS="2.7.15"
MIN_PYTHON_VERSION_LINUX="2.7.15"
PYTHON_PKG_LINUX="Python-${MIN_PYTHON_VERSION_LINUX}.tgz"
PYTHON_PKG_MACOS="python-${MIN_PYTHON_VERSION_MACOS}-macosx10.9.pkg"
export ANSIBLE_NOCOWS=1

if [[ $(id -u ${MAC_USER}) -eq 0 ]]; then
  echo "Please don't run under the root user!"
  exit 1
fi

sudo -H -u "${MAC_USER}" bash -c 'which brew && brew unlink python@2'

if [[ "Darwin" == "$(uname)" ]]; then
  # Install python if outdated
  if ! php -r "version_compare('"$(python --version 2>&1 | awk '{print $2}')"', '${MIN_PYTHON_VERSION_MACOS}', '>=') ? exit(0) : exit(1);" || ! which pip > /dev/null; then
    curl -o "/tmp/${PYTHON_PKG_MACOS}" "https://www.python.org/ftp/python/${MIN_PYTHON_VERSION_MACOS}/${PYTHON_PKG_MACOS}"
    sudo installer -pkg "/tmp/${PYTHON_PKG_MACOS}" -target /
    /Applications/Python\ 2.7/Install\ Certificates.command
  fi
  cd $(dirname $(which python)); cd $(dirname $(readlink $(which python)))

  if which brew; then
    brew unlink python@2
    hash svnsync
  fi

  # Install Ansible if not found or upgrade if outdated
 ./ansible --version >/dev/null 2>&1 \
  && php -r "version_compare('"$(./ansible --version  | head -1 | awk '{print $2}')"', '${MIN_ANSIBLE_VERSION}', '>=') ? exit(0) : exit(1);" || {
    sudo -H ./pip install --force-reinstall --upgrade ansible PyYAML
  }
  ANSIBLE_PLAYBOOK_BIN="./ansible-playbook"
  BREW_INSTALL_PATH="${BREW_INSTALL_PATH-/usr/local}"
else
  if [[ "Linux" == "$(uname)" ]]; then
    source /etc/os-release
    if [[ "debian" == "${ID}" ]] || [[ "debian" == "${ID_LIKE}" ]] || [[ "ubuntu" == "${ID_LIKE}" ]]; then
      apt-get update \
      && apt-get install -y --no-install-recommends ca-certificates git curl file systemtap-sdt-dev g++ make uuid-runtime python-pip

      if ! which pip > /dev/null || [[ ! -f $(which pip) ]] || ! $(which pip) --version > /dev/null; then
        sudo apt update && sudo apt install -yq python-apt python-pip
      fi
      if ! which ansible > /dev/null || [[ ! -f $(which ansible) ]]  || ! $(which ansible) --version > /dev/null || dpkg --compare-versions "$($(which ansible) --version 2>&1 | head -n1 | awk '{print $2}')" lt "${MIN_ANSIBLE_VERSION}"; then
        sudo pip install --ignore-installed --force-reinstall --upgrade ansible requests[security] httpie PyYAML || exit 1
      fi
      ANSIBLE_PLAYBOOK_BIN="$(which ansible-playbook)"
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
hash svnsync
sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_BIN} --version
sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_BIN} -i "localhost," -c local "${DIR}/main.yml" --extra-vars="ansible_python_interpreter=$(which python)" -e "mac_user=${MAC_USER}" -e "brew_install_path=${BREW_INSTALL_PATH}" "$@"

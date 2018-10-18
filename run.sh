#!/bin/bash
pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null

MAC_USER=${SUDO_USER-${USER}}
MIN_ANSIBLE_VERSION="2.4.4.0"
MIN_PYTHON_VERSION_MACOS="2.7.15"
MIN_PYTHON_VERSION_LINUX="2.7.15"
PYTHON_PKG_LINUX="Python-${MIN_PYTHON_VERSION_LINUX}.tgz"
PYTHON_PKG_MACOS="python-${MIN_PYTHON_VERSION_MACOS}-macosx10.9.pkg"

if [[ "Darwin" == "$(uname)" ]]; then
  # Install python if outdated
  if ! php -r "version_compare('"$(python --version 2>&1 | awk '{print $2}')"', '${MIN_PYTHON_VERSION_MACOS}', '>=') ? exit(0) : exit(1);" || ! which pip > /dev/null; then
    curl -o "/tmp/${PYTHON_PKG_MACOS}" "https://www.python.org/ftp/python/${MIN_PYTHON_VERSION_MACOS}/${PYTHON_PKG_MACOS}"
    sudo installer -pkg "/tmp/${PYTHON_PKG_MACOS}" -target /
  fi
  cd $(dirname $(which python)); cd $(dirname $(readlink $(which python)))

  # Install Ansible if not found or upgrade if outdated
  $(which ansible) --version >/dev/null 2>&1 \
  && php -r "version_compare('"$($(which ansible) --version  | head -1 | awk '{print $2}')"', '${MIN_ANSIBLE_VERSION}', '>=') ? exit(0) : exit(1);" || {
    sudo -H ./pip install --force-reinstall --upgrade ansible
  }
  ANSIBLE_PLAYBOOK_BIN="$(which ansible-playbook)"
  BREW_INSTALL_PATH="${BREW_INSTALL_PATH-/usr/local}"
else
  if [[ "Linux" == "$(uname)" ]]; then
    source /etc/os-release
    if [[ "debian" == "${ID_LIKE}" ]]; then
      if ! which python2.7 > /dev/null || dpkg --compare-versions "$(python2.7 --version 2>&1 | awk '{print $2}')" lt "${MIN_PYTHON_VERSION_LINUX}"; then
        cd /tmp
        sudo apt update
        sudo apt purge -yq python2.7*
        sudo apt install -yq curl git make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev liblzma-dev
        curl -o "/tmp/${PYTHON_PKG_LINUX}" "https://www.python.org/ftp/python/${MIN_PYTHON_VERSION_LINUX}/Python-${MIN_PYTHON_VERSION_LINUX}.tgz"
        [[ -d "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}" ]] && rm -rf "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}"
        mkdir -p "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}"
        sudo tar xzf "/tmp/${PYTHON_PKG_LINUX}" --strip 1 -C "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}"
        cd "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}"
        sudo ./configure --prefix=/usr --enable-optimizations
        sudo make
        # sudo make install
        sudo checkinstall -y --install=yes -D --provides=python --pkgname=python --pkgversion="${MIN_PYTHON_VERSION_LINUX}" --maintainer="$(whoami)@$(hostname)"
        sudo apt-mark hold python
      fi
      if ! which pip > /dev/null; then
        cd /tmp
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        sudo $(which python2.7) get-pip.py
      fi
      if ! which ansible > /dev/null || dpkg --compare-versions "$(ansible --version 2>&1 | head -n1 | awk '{print $2}')" lt "${MIN_ANSIBLE_VERSION}"; then
        sudo pip install --force-reinstall --upgrade ansible
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
sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_BIN} -i "localhost," -c local "${DIR}/main.yml" -e "mac_user=${MAC_USER}" -e "brew_install_path=${BREW_INSTALL_PATH}" "$@"

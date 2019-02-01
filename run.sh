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

if [[ "Darwin" == "$(uname)" ]]; then
  # Install python if outdated
  if ! php -r "version_compare('"$(python --version 2>&1 | awk '{print $2}')"', '${MIN_PYTHON_VERSION_MACOS}', '>=') ? exit(0) : exit(1);" || ! which pip > /dev/null; then
    curl -o "/tmp/${PYTHON_PKG_MACOS}" "https://www.python.org/ftp/python/${MIN_PYTHON_VERSION_MACOS}/${PYTHON_PKG_MACOS}"
    sudo installer -pkg "/tmp/${PYTHON_PKG_MACOS}" -target /
  fi
  cd $(dirname $(which python)); cd $(dirname $(readlink $(which python)))

  if which brew; then
    brew unlink python@2
  fi

  # Install Ansible if not found or upgrade if outdated
 ./ansible --version >/dev/null 2>&1 \
  && php -r "version_compare('"$(./ansible --version  | head -1 | awk '{print $2}')"', '${MIN_ANSIBLE_VERSION}', '>=') ? exit(0) : exit(1);" || {
    sudo -H ./pip install --force-reinstall --upgrade ansible PyYAML
  }
  ANSIBLE_PLAYBOOK_BIN="./ansible-playbook"
  ANSIBLE_GALAXY_BIN="./ansible-galaxy"
  BREW_INSTALL_PATH="${BREW_INSTALL_PATH-/usr/local}"
else
  if [[ "Linux" == "$(uname)" ]]; then
    source /etc/os-release
    if [[ "debian" == "${ID_LIKE}" ]] || [[ "ubuntu" == "${ID_LIKE}" ]]; then
#      if ! which python2.7 > /dev/null || dpkg --compare-versions "$(python2.7 --version 2>&1 | awk '{print $2}')" lt "${MIN_PYTHON_VERSION_LINUX}"; then
#        cd /tmp && \
#        sudo apt update && \
#        #sudo apt purge -yq python2.7*
#        sudo apt install -yq curl git make build-essential libssl-dev zlib1g-dev libbz2-dev \
#        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
#        xz-utils tk-dev libffi-dev liblzma-dev checkinstall
#        curl -o "/tmp/${PYTHON_PKG_LINUX}" "https://www.python.org/ftp/python/${MIN_PYTHON_VERSION_LINUX}/Python-${MIN_PYTHON_VERSION_LINUX}.tgz"
#        [[ -d "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}" ]] && rm -rf "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}"
#        mkdir -p "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}" && \
#        sudo tar xzf "/tmp/${PYTHON_PKG_LINUX}" --strip 1 -C "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}" && \
#        cd "/tmp/Python-${MIN_PYTHON_VERSION_LINUX}" && \
#        sudo ./configure --prefix=/usr --enable-optimizations
#        # sudo ./configure --enable-optimizations
#        sudo make
#        sudo make install
#        #sudo checkinstall -y --dpkgflags=--force-overwrite --install=yes -D --provides="python-ctypes, python-email, python-importlib, python-profiler, python-wsgiref" --pkgname=python --pkggroup=python --pkgversion="${MIN_PYTHON_VERSION_LINUX}" --pkgrelease=1$(echo $NAME | tr '[:upper:]' '[:lower:]')~${VERSION_ID} --maintainer="$(whoami)@$(hostname)" --pkgsource="https://www.python.org/ftp/python/${MIN_PYTHON_VERSION_LINUX}/Python-${MIN_PYTHON_VERSION_LINUX}.tgz"
#        #sudo apt-mark hold python || exit 1
#      fi

      sudo apt update
      sudo apt install -y software-properties-common
      printf '\n' | sudo apt-add-repository ppa:git-core/ppa
      sudo apt update && sudo apt install -yq python-apt python-pip curl git \
        make build-essential autoconf libssl-dev zlib1g-dev libbz2-dev \
#       libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev

      if ! which pip > /dev/null || [[ ! -f $(which pip) ]] || ! $(which pip) --version > /dev/null; then
        sudo apt update && sudo apt install -yq python-apt python-pip
#        cd /tmp && \
#        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
#        sudo $(which python2.7) get-pip.py || exit 1
      fi
      if ! which ansible > /dev/null || [[ ! -f $(which ansible) ]]  || ! $(which ansible) --version > /dev/null || dpkg --compare-versions "$($(which ansible) --version 2>&1 | head -n1 | awk '{print $2}')" lt "${MIN_ANSIBLE_VERSION}"; then
        sudo pip install --ignore-installed --force-reinstall --upgrade ansible requests[security] httpie PyYAML || exit 1
      fi
      ANSIBLE_PLAYBOOK_BIN="$(which ansible-playbook)"
      ANSIBLE_GALAXY_BIN="$(which ansible-galaxy)"
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
sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_BIN} --version
sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_BIN} -i "localhost," -c local "${DIR}/main.yml" -e "mac_user=${MAC_USER}" -e "brew_install_path=${BREW_INSTALL_PATH}" "$@"

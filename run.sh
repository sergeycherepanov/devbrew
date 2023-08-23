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
PYTHON_BIN=${PYTHON_BIN:-$(which python3 > /dev/null && which python3 || echo "/usr/bin/python3")}
ANSIBLE_PLAYBOOK_CMD="${PYTHON_BIN} ${DIR}/ansible-playbook"

if [[ $(id -u ${MAC_USER}) -eq 0 ]]; then
  echo "Please don't run this script under the root user!"
  exit 1
fi

if ! which brew; then
  echo "Homebrew not found! Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ $(uname -s) == 'Darwin' ]]; then
    if [[ $(uname -m) == 'arm64' ]]; then
      (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      (echo; echo 'eval "$(/usr/local/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
      eval "$(/usr/local/homebrew/bin/brew shellenv)"
    fi
  else
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> $HOME/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

hash -r

sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_CMD} --version
sudo -H -u "${MAC_USER}" ${ANSIBLE_PLAYBOOK_CMD} -i "localhost," -c local "${DIR}/main.yml" --extra-vars="ansible_python_interpreter=${PYTHON_BIN}" -e "mac_user=${MAC_USER}" -e "brew_install_path=$(brew --prefix)" "$@"

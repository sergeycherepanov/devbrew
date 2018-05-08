  #!/bin/bash
  pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null

  MAC_USER=${SUDO_USER-${USER}}
  MIN_ANSIBLE_VERSION="2.4.4.0"
  PYTHON_VERSION="2.7.15"
  PYTHON_PKG="python-2.7.15-macosx10.9.pkg"

  if ! php -r "version_compare('"$(python --version 2>&1 | awk '{print $2}')"', '${PYTHON_VERSION}', '>=') ? exit(0) : exit(1);" || ! which pip > /dev/null; then
    curl -o "/tmp/${PYTHON_PKG}" "https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_PKG}"
    sudo installer -pkg "/tmp/${PYTHON_PKG}" -target /
  fi

  cd $(dirname $(which python)); cd $(dirname $(readlink $(which python)))

  # Install ansible if not found or upgrade if outdated
  ./ansible --version >/dev/null 2>&1 \
  && php -r "version_compare('"$(./ansible --version  | head -1 | awk '{print $2}')"', '${MIN_ANSIBLE_VERSION}', '>=') ? exit(0) : exit(1);" || {
    sudo -H ./pip install --force-reinstall --upgrade ansible==${MIN_ANSIBLE_VERSION}
  }

  sudo -H -u ${MAC_USER} ./ansible-playbook -i "localhost," -c local "${DIR}/main.yml" -e "mac_user=${MAC_USER}" "$@"

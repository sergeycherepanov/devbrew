#!/bin/bash

# Enable memory and swap accounting
sed -i -e \
  's/^GRUB_CMDLINE_LINUX=.+/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' \
  /etc/default/grub
sudo update-grub

# Clean up
for SERVICE in "chef-client" "puppet"; do
    sudo /usr/sbin/update-rc.d -f $SERVICE remove
    sudo rm /etc/init.d/$SERVICE
    sudo pkill -9 -f $SERVICE
done
sudo apt-get autoremove -qqy chef puppet
sudo apt-get -qq clean
sudo rm -f \
  ${USERHOME}/*.sh       \
  ${USERHOME}/.vbox_*    \
  ${USERHOME}/.veewee_*  \
  /var/log/messages   \
  /var/log/lastlog    \
  /var/log/auth.log   \
  /var/log/syslog     \
  /var/log/daemon.log \
  /var/log/docker.log
sudo rm -rf  \
  /var/log/chef       \
  /var/chef           \
  /var/lib/puppet


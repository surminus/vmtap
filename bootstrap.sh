#!bin/bash
apt-get update
apt-get install -y --force-yes git puppet puppet-common
mv /etc/puppet /etc/puppet.bak
git clone https://github.com/surminus/puppet.git /etc/puppet
puppet apply /etc/puppet/manifests/init.pp

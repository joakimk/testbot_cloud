#!/bin/sh
export DEBIAN_FRONTEND=noninteractive

apt-get update &&
apt-get -y install curl wget ruby ruby-dev libopenssl-ruby &&
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz &&
tar xvfz rubygems-1.3.7.tgz && cd rubygems-1.3.7 && ruby setup.rb && ln -s /usr/bin/gem1.8 /usr/bin/gem

su ubuntu -c 'GEM_HOME="~/.gem" gem install testbot --no-ri --no-rdoc'

# Ramdisk for fast rsync
echo 'none            /tmp            tmpfs   defaults        0       0' >> /etc/fstab
mount -a

cd /home/ubuntu
mv bootstrap/ssh/* .ssh/
chown -R ubuntu .ssh
chmod 0600 .ssh/id_rsa

# TODO:
# Haven't gotten auto_update to run using this cloud setup
# script yet, it updates but does not restart the process. 

su ubuntu -c 'export PATH="$HOME/.gem/bin:$PATH"; export GEM_HOME="$HOME/.gem"; testbot --runner --ssh_tunnel --auto_update --connect your_server_host'


#!/bin/sh
export DEBIAN_FRONTEND=noninteractive

apt-get update &&
apt-get -y install curl wget ruby ruby-dev libopenssl-ruby &&
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz &&
tar xvfz rubygems-1.3.7.tgz && cd rubygems-1.3.7 && ruby setup.rb && ln -s /usr/bin/gem1.8 /usr/bin/gem &&
gem install testbot --no-ri --no-rdoc

# Ramdisk for fast rsync
echo 'none            /tmp            tmpfs   defaults        0       0' >> /etc/fstab
mount -a

cd /home/ubuntu
mv bootstrap/ssh/* .ssh/
chown -R ubuntu .ssh
chmod 0600 .ssh/id_rsa

su ubuntu -c "testbot --runner --ssh_tunnel --connect your_server_host"


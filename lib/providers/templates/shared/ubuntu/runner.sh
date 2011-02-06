#!/bin/sh
~/bootstrap/shared.sh

# Ramdisk for fast rsync
echo 'none            /tmp            tmpfs   defaults        0       0' >> /etc/fstab
mount -a

cd /home/ubuntu
mv bootstrap/ssh/* .ssh/
chown -R ubuntu .ssh
chmod 0600 .ssh/id_rsa

su ubuntu -c "testbot --runner --ssh_tunnel --connect your_server_host"


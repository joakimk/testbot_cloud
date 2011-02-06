export DEBIAN_FRONTEND=noninteractive

apt-get update &&
apt-get -y install curl wget ruby ruby-dev libopenssl-ruby &&
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz &&
tar xvfz rubygems-1.3.7.tgz && cd rubygems-1.3.7 && ruby setup.rb && ln -s /usr/bin/gem1.8 /usr/bin/gem &&
gem install testbot --no-ri --no-rdoc


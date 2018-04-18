#!/bin/bash
set -eu -o pipefail

# install build deps
add-apt-repository ppa:ethereum/ethereum
apt-get update
apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk zsh haskell-platform

# install golang
GOREL=go1.9.3.linux-amd64.tar.gz
wget -q https://dl.google.com/go/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
PATH=$PATH:/usr/local/go/bin
GOPATH=/home/vagrant/go
PATH=$PATH:$GOPATH/bin

# (optional) install zsh
chsh -s $(which zsh)
echo 'export SHELL=/bin/zsh' >> .bash_profile
echo 'exec /bin/zsh -l' >> .bash_profile
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
curl -L git.io/antigen > antigen.zsh # install antigen
cp /vagrant/.zshrc /home/vagrant/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions # plugin

# setting env var in zsh
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.zshrc
echo 'export GOPATH=$HOME/go' >> /home/vagrant/.zshrc
echo 'export PATH=$PATH:$GOPATH/bin' >> /home/vagrant/.zshrc

# clone repos
git clone https://github.com/Szkered/quorum.git $GOPATH/src/github.com/ethereum/go-ethereum
git clone https://github.com/Szkered/constellation.git
git clone https://github.com/Szkered/quorum-tools.git
chown -R vagrant:vagrant /home/vagrant/quorum-tools /home/vagrant/constellation

# install geth dependencies
cd $GOPATH/src/github.com/ethereum/go-ethereum
go install -v ./...

# install haskell tools
curl -sSL https://get.haskellstack.org/ | sh  # stack

# done!
banner "Quorum Dev Box"
echo
echo 'The Quorum vagrant instance has been provisioned.'
echo "Use 'vagrant ssh' to open a terminal, 'vagrant suspend' to stop the instance, and 'vagrant destroy' to remove it."

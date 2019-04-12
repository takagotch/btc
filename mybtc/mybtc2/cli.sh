git clone https://github.com/bitcoin/bitcoin.git

cd bitcoin
git tag

git checkout -b 0.16.0 refs/tags/v0.16.0

brew install automake berkeley-db4 libtool boost --c+11 miniupnpc openssl pkg-config homebrew/versions/protobuf260 --c+11 qt5 libevent

./autogen.sh
./configure
make -j4
make install

which bitcoind
which bitcoin-cli

sudo apt-add-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install bitcoind bitcoin-qt

sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils

sudo apt-get install libboot-system-dev liboost-filesystem-dev liboost-chrono-dev liboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get install libboost-all-dev

sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install lidb4.8-dev libdb4.8++-dev

sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 attools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
sudo apt-get install libqrencode-dev


bitcoin-qt &
bitcoin -daemon
bitcoin -regtest -daemon
bitcoin-cli stop

bitcoin-cli getblockchaininfo
curl loclahost:18332/rest/chaininfo.json
bitcoin-cli getconnectioncount
bitcoin-cli getpeerinfo
bitcoin-cli -regtest generate 3
sudo gem install bitcoin-ruby
sudo apt install ruby

sudo gem install openassets-ruby
sudo apt-get install ruby-dev
sudo apt-get install libsqlite3-dev



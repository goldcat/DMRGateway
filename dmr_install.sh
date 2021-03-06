#! /bin/sh

#################################################
#                                               #
# Create directory structure for DMRlink        #
#                                               #
#################################################

apt-get update

# Checkout DMRlink and put it in /opt
cd /srv
git clone https://github.com/n0mjs710/DMRlink.git
cd /srv/DMRlink/
./mk_dmrlink

# setup boot for DV3000
cd /srv
git clone https://github.com/N4IRS/DMRGateway.git
cd /srv/DMRGateway/
systemctl stop getty@ttyAMA0.service
systemctl disable getty@ttyAMA0.service
cp config.txt /boot
cp cmdline.txt /boot

# Setup WiringPi
cd /srv
apt-get install -y sudo
git clone git://git.drogon.net/wiringPi
cd wiringPi/
./build

# Setup AMBEserverGPIO
cd /srv
git clone https://github.com/dl5di/OpenDV.git
mv OpenDV/DummyRepeater/DV3000 DV3000
rm -rf OpenDV
cd DV3000/
make clean
make
make install
make init-install
python AMBEtest3.py
cd /etc/init.d
update-rc.d AMBEserverGPIO start 50 2 3 4 5

# Setup DMRGateway
cd /srv/DMRGateway/
./install.sh

# reboot



#!/bin/sh

echo "===> Update&install all needed packages"

apk update && apk add --no-cache binutils e2fsprogs util-linux iproute2 \
		libarchive-tools bash sudo dnsmasq wget unzip tar iptables \
		coreutils qemu-system-arm qemu-system-aarch64
		
echo "===> Networking settings ..."
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200

## install_from_git
install_from_git() {
	cd /home
	wget https://github.com/M0Rf30/simonpi/archive/master.zip
	unzip master.zip
	cd simonpi-master
	install -Dm755 simonpi /usr/bin/simonpi
	install -dm755 /opt/simonpiemu/
	cp simonpiemu/* /opt/simonpiemu/
	sed -i "s/OPT=./OPT=\/opt/g" /usr/bin/simonpi
	cd ..
	rm -rf simonpi-master master.zip
}

echo "===> install simonpi"
install_from_git simonpi

echo "===> DONE $0 $*"


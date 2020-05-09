#!/bin/sh

echo "===> Update&install all needed packages"

apk update && apk add --no-cache bash binutils coreutils dnsmasq dosfstools e2fsprogs \
    file grep iproute2 iptables libarchive-tools qemu-img \
qemu-system-arm qemu-system-aarch64 rpm2cpio sudo unzip util-linux curl

echo "===> Networking settings ..."
# Create the kvm node (required --privileged)
if [ ! -e /dev/kvm ]; then
	set +e
	mknod /dev/kvm c 10 "$(grep '\<kvm\>' /proc/misc | cut -f 1 -d' ')"
	set -e
fi

# If we have a BRIDGE_IF set, add it to /etc/qemu/bridge.conf
mkdir -p /etc/qemu
echo "allow rasp-br0" >> /etc/qemu/bridge.conf

# Make sure we have the tun device node
if [ ! -e /dev/net/tun ]; then
	set +e
	mkdir -p /dev/net
	mknod /dev/net/tun c 10 $(grep '\<tun\>' /proc/misc | cut -f 1 -d' ')
	set -e
fi

## download
download() {
	curl -L -O -C - $1
}

## install_from_git
install_from_git() {
	cd /home
	download https://github.com/M0Rf30/simonpi/archive/master.zip
	unzip master.zip
	cd simonpi-master
	install -Dm755 simonpi /usr/bin/simonpi
	install -dm755 /opt/simonpiemu/
	cp -r simonpiemu/* /opt/simonpiemu/
	sed -i "s/OPT=./OPT=\/opt/g" /usr/bin/simonpi
	cd ..
	rm -rf simonpi-master master.zip

	# Need to be manually bumped
	fedora_ver=32
	pkgver=20200201
	pkgrel=1

	# OVMF ARM
    download "https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/${fedora_ver}/Everything/x86_64/os/Packages/e/edk2-arm-${pkgver}stable-${pkgrel}.fc${fedora_ver}.noarch.rpm"
	rpm2cpio edk2-arm-${pkgver}stable-${pkgrel}.fc${fedora_ver}.noarch.rpm
	# OVMF AARCH64
	download "https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/${fedora_ver}/Everything/x86_64/os/Packages/e/edk2-aarch64-${pkgver}stable-${pkgrel}.fc${fedora_ver}.noarch.rpm"
	rpm2cpio edk2-aarch64-${pkgver}stable-${pkgrel}.fc${fedora_ver}.noarch.rpm
	cp -av usr /
	cd /usr/share/AAVMF
  	ln -sf ../edk2/arm/vars-template-pflash.raw AAVMF32_VARS.fd
}

echo "===> Installing Sim on Pi"
install_from_git simonpi

echo "===> DONE $0 $*"


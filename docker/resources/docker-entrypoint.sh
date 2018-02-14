#!/bin/bash

echo "===> Update&install all needed packages"

pacman -Suy --noconfirm --noprogressbar binutils \
		fakeroot git dnsmasq dosfstools \
		iproute2 iptables qemu-headless-arch-extra \
		sudo wget libseccomp

echo "===> enable sudo from nobody with nopasword, for 'sudo -u nobody makepkg -i' to work"
echo "nobody ALL=(ALL:ALL) NOPASSWD: ALL" | (VISUAL="tee -a" EDITOR="tee -a" visudo)

echo "===> FIX stupid bug when sudo inside docker"
#http://bit-traveler.blogspot.com/2015/11/sudo-error-within-docker-container-arch.html
sed -e "/nice/s/\*/#*/" -i /etc/security/limits.conf

echo "===> Networking settings ..."
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 $(grep '\<tun\>' /proc/misc | cut -f 1 -d' ')

## install_from_aur
install_from_aur() {
	local name=$1
	local tmpdir=/home/$name
	git clone https://aur.archlinux.org/$name.git $tmpdir
	chown nobody:nobody -R $tmpdir
	pushd $tmpdir
	sudo -Eu nobody makepkg --noconfirm --nosign -si
	popd
	rm -rf $tmpdir
}

echo "===> install yaourt"
install_from_aur simonpi-git

echo "===> cleanup"
yes Y | pacman -Scc

echo "===> DONE $0 $*"


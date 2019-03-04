#!/bin/sh

echo "===> Update&install all needed packages"

apk update && apk add --no-cache bash binutils coreutils dnsmasq dosfstools e2fsprogs \
    file grep iproute2 iptables libarchive-tools qemu-img \
    qemu-system-arm qemu-system-aarch64 sudo tar unzip util-linux

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

## install_from_git
install_from_git() {
    cd /home
    curl -L -O -C - https://github.com/M0Rf30/simonpi/archive/master.zip
    unzip master.zip
    cd simonpi-master
    install -Dm755 simonpi /usr/bin/simonpi
    install -dm755 /opt/simonpiemu/
    cp -r simonpiemu/* /opt/simonpiemu/
    sed -i "s/OPT=./OPT=\/opt/g" /usr/bin/simonpi
    cd ..
    rm -rf simonpi-master master.zip
    
    # OVMF ARM
    wget http://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/latest/QEMU-ARM/RELEASE_GCC5/QEMU_EFI.fd
    install -D -m644 QEMU_EFI.fd /usr/share/ovmf/ARM/QEMU_EFI.fd
    rm QEMU_EFI.fd
    # OVMF AARCH64
    wget http://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/latest/QEMU-AARCH64/RELEASE_GCC5/QEMU_EFI.fd
    install -D -m644 QEMU_EFI.fd /usr/share/ovmf/AARCH64/QEMU_EFI.fd
    rm QEMU_EFI.fd
}

echo "===> Installing Sim on Pi"
install_from_git simonpi

echo "===> DONE $0 $*"


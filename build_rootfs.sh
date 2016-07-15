#!/bin/bash

set -ex

apt-get install qemu qemu-kvm\
        debootstrap

sudo debootstrap \
        --arch=arm64 \
        --verbose \
        --foreign \
        --components=main,restricted,universe,multiverse \
        --include=docker.io,curl,zsh,git,git-core,openssl,openssh-server,sudo \
        $1 \
        $1-rootfs

cp /usr/bin/qemu-aarch64-static $1-rootfs/usr/bin
cp resize_rootfs.sh $1-rootfs/root/

chroot $1-rootfs /bin/bash /debootstrap/debootstrap --second-stage
chroot $1-rootfs useradd -m -G adm,sudo -p $(openssl passwd -1 ubuntu) ubuntu 
chroot $1-rootfs apt-get clean
chroot $1-rootfs apt-get autoremove
chroot $1-rootfs apt-get autoclean

cd $1-rootfs ; tar -cvf ../$1-rootfs.tar . ; cd ..
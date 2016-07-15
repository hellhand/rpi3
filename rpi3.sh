# #!/bin/bash

# varialbes
VERSION=xenial
ROOT_FS=$VERSION-rootfs.tar
##

set -ex

./prepare_boot.sh
./build_rootfs.sh $VERSION

#sudo umount -f /mnt/bootenv
#sudo umount -f /mnt

/bin/echo -e "d\n2\nn\np\n2\n143360\n\nw\n" | sudo fdisk /dev/mmcblk0

sudo mkfs.ext4 -F -b 4096 -L rootfs /dev/mmcblk0p2

sudo rm -Rf /mnt

sudo mkdir /mnt
sudo mount /dev/mmcblk0p2 /mnt

sudo mkdir /mnt/bootenv
sudo mount /dev/mmcblk0p1 /mnt/bootenv

sudo tar --numeric-owner -C /mnt -xvf $ROOT_FS
sudo cp firmware/boot/* /mnt/bootenv

sudo umount /mnt/bootenv
sudo umount /mnt

sync; sync

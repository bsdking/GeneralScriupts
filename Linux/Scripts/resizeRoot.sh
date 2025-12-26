#!/bin/bash

# NOTE: Replace 'sda3' with your actual physical volume device (check with lsblk)
PHYSICAL_DEVICE="/dev/vda4" 

# NOTE: Replace 'volume-group-name-root' with your actual logical volume name (check with df -h or lvdisplay)
LOGICAL_VOLUME_PATH="/dev/mapper/systemVG-LVRoot" 

echo "Install cloud-utils..."
dnf -y install cloud-utils

echo "Resizing physical partition..."
# Use growpart to expand the partition to fill available space
# (You may need to install 'cloud-utils' package for growpart)
growpart /dev/vda4

echo "Informing the kernel about the partition size change..."
partprobe

echo "Resizing LVM physical volume..."
pvresize "$PHYSICAL_DEVICE"

echo "Extending LVM logical volume to use all free space and resizing filesystem..."
# The -r flag automatically resizes the filesystem inside the LVM volume
lvextend -r -l +100%FREE "$LOGICAL_VOLUME_PATH"

echo "Verification:"
df -h

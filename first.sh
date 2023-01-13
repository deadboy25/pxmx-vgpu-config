#! /bin/bash

# create required directories
mkdir /opt/vgpu_setup
mkdir /etc/systemd/system/nvidia-vgpud.service.d
mkdir /etc/systemd/system/nvidia-vgpu-mgr.service.d

# populate working directory and enter it
cp NVIDIA-Linux-x86_64-510.108.03-vgpu-kvm.run /opt/vgpu_setup
cd /opt/vgpu_setup

# add community repo to apt sources and comment out enterprise repo
echo 'deb http://download.proxmox.com/debian/pve buster pve-no-subscription' >> /etc/apt/sources.list
sed -i '1s/^/#/' /etc/apt/sources.list.d/pve-enterprise.list

# update, upgrade, and install necessary packages
apt update
apt -y upgrade
apt -y install git build-essential pve-headers dkms jq mdevctl

# clone required github repos
git clone https://github.com/DualCoder/vgpu_unlock
git clone https://github.com/mbilker/vgpu_unlock-rs

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh
bash rustup.sh -y
rm rustup.sh

# install pve headers (for kernel version 5.15.74, this may change!)
wget http://download.proxmox.com/debian/dists/bullseye/pve-no-subscription/binary-amd64/pve-headers-5.15.74-1-pve_5.15.74-1_amd64.deb
dpkg -i pve-headers-5.15.74-1-pve_5.15.74-1_amd64.deb
rm pve-headers-5.15.74-1-pve_5.15.74-1_amd64.deb

# enable iommu for intel (will not work for AMD systems)
sed -i '9s/^/GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"\n#/' /etc/default/grub
update-grub

# emable required modules
echo 'vfio' >> /etc/modules
echo 'vfio_iommu_type1' >> /etc/modules
echo 'vfio_pci' >> /etc/modules
echo 'vfio_virqfd' >> /etc/modules

# blacklist generic GPU driver
echo "options kvm ignore_msrs=1" > /etc/modprobe.d/kvm.conf
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
update-initramfs -u

# configure other script to execute on reboot?

# reboot to install
reboot

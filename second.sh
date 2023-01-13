#! /bin/bash

# enter working directory
#cd /opt/vgpu_setup

# make host driver executable and install as kernel module
chmod +x /opt/vgpu_setup/NVIDIA-Linux-x86_64-510.108.03-vgpu-kvm.run #TODO: test
echo "Select Yes when asked "
sleep 5
/opt/vgpu_setup/NVIDIA-Linux-x86_64-510.108.03-vgpu-kvm.run --dkms

sed -i '30s|^|#include "/opt/vgpu_setup/vgpu_unlock/vgpu_unlock_hooks.c"|' /usr/src/nvidia-510.108.03/nvidia/os-interface.c
echo ldflags-y += -T /opt/vgpu_setup/vgpu_unlock/kern.ld >> /usr/src/nvidia-510.108.03/nvidia/kern.ld

cd /opt/vgpu_setup/vgpu_unlock-rs
cargo build --release
echo REBOOTING IN 5
sleep 5
reboot

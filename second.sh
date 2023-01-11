#! /bin/bash

# enter working directory
cd /opt/vgpu_setup

# make host driver executable and install as kernel module
chmod +x NVIDIA-Linux-x86_64-510.108.03-bgpu-kvm.run #TODO: test
echo "Select Yes when asked "
sleep 5
./NVIDIA-Linux-x86_64-510.108.03-bgpu-kvm.run --dkms

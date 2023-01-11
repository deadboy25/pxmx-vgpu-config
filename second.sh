#! /bin/bash

#TODO: get host driver

# make host driver executable and install as kernel module
chmod +x NVIDIA-Linux-x86_64-510.108.03-bgpu-kvm.run #TODO: check spelling, path may need to be changed 
echo "Select Yes when asked "
./NVIDIA-Linux-x86_64-510.108.03-bgpu-kvm.run --dkms

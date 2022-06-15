#!/bin/bash
cd bb-kernel
./build_kernel.sh
#to just rebuild, without updating
#tools/rebuild.sh
cd ../buildroot
#rebuild target 
#find output/ -name ".stamp_target_installed" -delete
make beaglebone_exp_defconfig
make -j4
#rebuild kernel
#make linux-dirclean
#make linux-rebuild


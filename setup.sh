#!/bin/bash
# for reference only, RISCV. See install_all.sh
# on a completely new system:
THIS_RISCV=riscv32i
THIS_RISCV_PATH=/opt/$THIS_RISCV/bin
MIN_ULX3S_MEMORY=5050000

if [ $(free | grep Mem | awk '{ print $2 }') -lt $MIN_ULX3S_MEMORY ]; then
  echo ""
  echo "System memory found:"
  free
  echo ""
  read -p "Warning: At least $MIN_ULX3S_MEMORY bytes of memory is needed. Press a key to continue"
fi


sudo apt-get update --assume-yes 
sudo apt-get upgrade --assume-yes
sudo apt-get install git --assume-yes

cd ~
mkdir -p ~/workspace
cd workspace

git clone https://github.com/rxrbln/picorv32.git

cd picorv32

sudo apt-get install make        --assume-yes
sudo apt-get install make-guile  --assume-yes
sudo apt-get install libgmp3-dev --assume-yes
sudo apt-get install libmpfr-dev --assume-yes
sudo apt-get install libmpc-dev  --assume-yes

sudo apt-get install autoconf automake autotools-dev curl libmpc-dev \
        libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
    gperf libtool patchutils bc zlib1g-dev git libexpat1-dev --assume-yes


make download-tools

# install *all four* riscv flavor toolchains:
# make -j$(nproc) build-tools

# or install only riscv32i:
sudo mkdir /opt/riscv32i
sudo chown $USER /opt/riscv32i

git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i
cd riscv-gnu-toolchain-rv32i
git checkout 411d134

# if you see fatal: clone of 'git://  ... 
# users sitting behind a firewall may need these:
git config --global url.https://github.com/.insteadOf git://github.com/
git config --global url.https://git.qemu.org/git/.insteadOf git://git.qemu-project.org/
git config --global url.https://anongit.freedesktop.org/git/.insteadOf git://anongit.freedesktop.org/
git config --global url.https://github.com/riscv.insteadOf git://github.com/riscv

# this next statement takes a long time. be patient:
git submodule update --init --recursive

mkdir build; cd build
../configure --with-arch=rv32i --prefix=/opt/riscv32i
make -j$(nproc)

# see if it is working:
/opt/riscv32i/bin/riscv32-unknown-elf-gcc --version

# add to path
if [ "$(cat ~/.bashrc | grep  $THIS_RISCV_PATH)" == "" ]; then
  echo PATH=$PATH:$THIS_RISCV_PATH >> ~/.bashrc
  echo "~/.bashrc updated with this line:"
  echo PATH=$PATH:$THIS_RISCV_PATH
else
  echo "Found $THIS_RISCV_PATH in ~/.bashrc - path not changed."
fi

if [ "$(echo $PATH | grep  $THIS_RISCV_PATH)" == "" ]; then
  export PATH=$PATH:$THIS_RISCV_PATH
  echo "Updated current path: $PATH"
else
  echo "Path not updated. PATH=$PATH"
fi

cd ~/workspace
git clone https://gist.github.com/gojimmypi/f96cd86b2b8595b4cf3be4baf493c5a7 ulx3s_fpga_toolchain
cd ulx3s_fpga_toolchain
chmod +x ULX3S_WSL_Toolchain.sh
./ULX3S_WSL_Toolchain.sh



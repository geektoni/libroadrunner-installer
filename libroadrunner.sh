#!/bin/bash

install_roadrunner()
{
  cd /tmp/build

  mkdir roadrunner && cd roadrunner/

  git clone https://github.com/sys-bio/roadrunner.git
  git clone https://github.com/sys-bio/libroadrunner-deps

  mkdir -p install/roadrunner

  cd libroadrunner-deps/
  mkdir build && cd build
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../../install/roadrunner ..
  make -j4 && make install

  cd ../../roadrunner/
  git checkout llvm-6
  mkdir build && cd build
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../../install/roadrunner -DLLVM_CONFIG_EXECUTABLE=/usr/bin/llvm-config-6.0 -DTHIRD_PARTY_INSTALL_FOLDER=../../install/roadrunner -DRR_USE_CXX11=OFF -DUSE_TR1_CXX_NS=ON LIBSBML_LIBRARY=/tmp/build/roadrunner/install/roadrunner/lib/libsbml.so LIBSBML_STATIC_LIBRARY=/tmp/build/roadrunner/install/roadrunner/lib/libsbml-static.a ..
  make -j4 && make install
}

build_example()
{
  cd /tmp/build/example
  mkdir build
  cd build
  cmake ../
  make -j 4
  ./libroadrunner-example
  if [ $? -eq 0 ]; then
    echo "libroadrunner was compiled successfully"
  else
    echo "libroadrunner was not compiled successfully"
  fi
}

OS=$1

# Install the given prerequisites and run a docker container with the selected system.
# MacOS will run natively
if [ ${OS} = 'ubuntu:18.04' ]; then
  apt-get update
  apt-get install -y \
  git \
  sudo \
  lsb-release \
  lsb-core \
  man \
  software-properties-common \
  wget
  apt-get update
  sudo apt-get install -y g++-5 cmake make wget
  sudo apt-get install -y llvm-6.0 llvm-6.0-dev llvm-6.0-runtime
  sudo apt-get install -y libbz2-1.0 libbz2-dev zlibc libxml2-dev libz-dev
  sudo apt-get install -y libncurses5-dev

elif [ ${OS} = 'ubuntu:16.04' ]; then
  apt-get update
  apt-get install -y \
  git \
  sudo \
  lsb-release \
  lsb-core \
  man \
  software-properties-common \
  wget
  apt-get update
  sudo apt-get install -y g++-5 cmake make wget
  sudo apt-get install -y llvm-6.0 llvm-6.0-dev llvm-6.0-runtime
  sudo apt-get install -y libbz2-1.0 libbz2-dev zlibc libxml2-dev libz-dev
  sudo apt-get install -y libncurses5-dev


elif [ ${OS} = 'centos:7' ]; then
  yum update -y
  yum install -y \
  git \
  sudo \
  redhat-lsb \
  redhat-lsb-core \
  man \
  wget \
  yum -y install centos-release-scl epel-release
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm
  yum install -y devtoolset-7-gcc*
  yum install -y llvm-toolset-6-*
  yum install -y ncurses-devel
  yum install -y libxml2-devel
  yum install -y libzip2 libzip2-devel
  yum install -y zlib zlib-devel

  # Enable CXX
  . scl_source enable devtoolset-7

else
  brew install llvm@6
  brew install swig
  brew install git
  brew install cmake

  export CXX=/usr/local/opt/llvm@3.9/bin/clang++
  export CC=/usr/local/opt/llvm@3.9/bin/clang
fi

# Compile the library
install_roadrunner

# Check if the example works
build_example

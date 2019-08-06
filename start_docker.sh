#!/bin/bash

OS=$1

# Move to tmp
mkdir /tmp/build

# Copy the install file and the example
cp libroadrunner.sh /tmp/build
cp -r example /tmp/build

# Move to the build dir
cd /tmp/build

# Install the system
if [ ${OS} != 'osx' ]; then
  sudo docker stop container || true
  sudo docker rm container || true
  docker run --network=host -itd -v /tmp/build:/tmp/build --name container ${OS} bash
  sudo docker exec -ti container bash -c "cd /tmp/build && bash ./libroadrunner.sh ${OS}"
else
  cd /tmp/build
  bash ./libroadrunner.sh ${OS}
fi

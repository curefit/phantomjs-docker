#!/usr/bin/env bash

set -x
set -e

apt update
apt install -y curl openssl libfontconfig1

ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

if [[ "${ARCH}" == "x86_64" ]] ;then
  ARCH="amd64"
  curl -kL https://static.cure.fit/phantomjs/phantomjs-2.1.1-amd64.deb -o phantomjs-amd64.deb
  apt -f -y install ./phantomjs-amd64.deb
elif [[ "${ARCH}" == "aarch64" ]] ;then
  ARCH="arm64"
  curl -kL https://static.cure.fit/phantomjs/phantomjs-2.1.1-arm64.deb -o phantomjs-arm64.deb
  apt -f -y install ./phantomjs-arm64.deb
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

echo "PhantomJS path: $(which phantomjs)"

echo "PhantomJS version: $(phantomjs --version)"

echo "PhantomJS dependencies: $(which phantomjs | xargs ldd)"

echo "PhantomJS installed successfully"

set +e
set +x

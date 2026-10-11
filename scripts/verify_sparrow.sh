#!/bin/bash
set -e

SPARROW_VER="2.5.5"
FILE_NAME="sparrowwallet-${SPARROW_VER}-x86_64.tar.gz"
DEST_DIR="config/includes.chroot/opt"

mkdir -p "$DEST_DIR"
cd "$DEST_DIR"

echo "-> Downloading Sparrow Wallet v$SPARROW_VER..."
wget -q -O "${FILE_NAME}" "https://github.com/sparrowwallet/sparrow/releases/download/${SPARROW_VER}/${FILE_NAME}"
wget -q -O manifest.txt "https://github.com/sparrowwallet/sparrow/releases/download/${SPARROW_VER}/sparrow-${SPARROW_VER}-manifest.txt"
wget -q -O manifest.txt.asc "https://github.com/sparrowwallet/sparrow/releases/download/${SPARROW_VER}/sparrow-${SPARROW_VER}-manifest.txt.asc"

echo "-> Importing Craig Raw's PGP Key..."
curl -sS https://keybase.io/craigraw/pgp_keys.asc | gpg --import

echo "-> Verifying PGP Signature..."
gpg --verify manifest.txt.asc manifest.txt

echo "-> Verifying Checksum..."
sha256sum --check --ignore-missing manifest.txt

echo "-> Unpacking..."
tar -xzf "${FILE_NAME}"
mv Sparrow sparrow
rm "${FILE_NAME}" manifest.txt manifest.txt.asc

echo "-> Sparrow Wallet successfully staged for OS build."
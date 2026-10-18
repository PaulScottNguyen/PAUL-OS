#!/bin/bash
set -e
echo "[*] Fetching Sparrow Wallet v2.5.5..."
wget --show-progress https://github.com/sparrowwallet/sparrow/releases/download/2.5.5/sparrowwallet-2.5.5-x86_64.tar.gz
wget --show-progress https://github.com/sparrowwallet/sparrow/releases/download/2.5.5/sparrow-2.5.5-manifest.txt
wget --show-progress https://github.com/sparrowwallet/sparrow/releases/download/2.5.5/sparrow-2.5.5-manifest.txt.asc

echo "-> Importing Craig Raw's PGP Key..."
curl -s https://keybase.io/craigraw/pgp_keys.asc | gpg --import

echo "-> Verifying PGP Signature on Manifest..."
gpg --verify sparrow-2.5.5-manifest.txt.asc sparrow-2.5.5-manifest.txt

echo "-> Verifying Archive Checksum..."
sha256sum --check sparrow-2.5.5-manifest.txt --ignore-missing

echo "-> Unpacking..."
tar -xzf sparrowwallet-2.5.5-x86_64.tar.gz
mkdir -p config/includes.chroot/opt

# Wipe any leftover folder from a previous aborted build
rm -rf config/includes.chroot/opt/sparrow
mv Sparrow config/includes.chroot/opt/sparrow

# Inject Hardware Wallet permissions into the core OS
echo "-> Staging Hardware Wallet udev rules..."
mkdir -p config/includes.chroot/etc/udev/rules.d
cp config/includes.chroot/opt/sparrow/lib/runtime/conf/udev/*.rules config/includes.chroot/etc/udev/rules.d/

# Forceful cleanup
rm -f sparrowwallet-2.5.5-x86_64.tar.gz
rm -f sparrow-2.5.5-manifest.txt*

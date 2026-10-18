#!/bin/bash
set -e
echo "[*] Fetching Ian Coleman BIP39 Standalone Tool v0.5.4..."
wget -q https://github.com/iancoleman/bip39/releases/download/0.5.4/bip39-standalone.html

echo "-> Staging for OS build..."
mkdir -p config/includes.chroot/opt/bip39
mv bip39-standalone.html config/includes.chroot/opt/bip39/

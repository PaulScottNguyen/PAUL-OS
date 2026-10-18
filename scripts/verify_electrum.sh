#!/bin/bash
set -e
echo "[*] Fetching Electrum Wallet v4.8.2..."
wget --show-progress -qO electrum-4.8.2-x86_64.AppImage https://download.electrum.org/4.8.2/electrum-4.8.2-x86_64.AppImage
wget --show-progress -qO electrum-4.8.2-x86_64.AppImage.asc https://download.electrum.org/4.8.2/electrum-4.8.2-x86_64.AppImage.asc

echo "-> Importing ThomasV's PGP Key..."
wget -qO- https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc | gpg --import

echo "-> Verifying PGP Signature..."
set +e
VERIFY_OUT=$(gpg --verify electrum-4.8.2-x86_64.AppImage.asc electrum-4.8.2-x86_64.AppImage 2>&1)
echo "$VERIFY_OUT"

# Check if the text "Good signature" exists in the output
if ! echo "$VERIFY_OUT" | grep -q "Good signature from"; then
    echo "FATAL: Electrum PGP verification failed!"
    exit 1
fi
set -e

echo "-> Extracting AppImage to bypass FUSE..."
chmod +x electrum-4.8.2-x86_64.AppImage
./electrum-4.8.2-x86_64.AppImage --appimage-extract

echo "-> Staging extracted wallet for OS build..."
mkdir -p config/includes.chroot/opt/electrum
cp -a squashfs-root/. config/includes.chroot/opt/electrum/

# Forceful cleanup
rm -rf squashfs-root
rm -f electrum-4.8.2-x86_64.AppImage*

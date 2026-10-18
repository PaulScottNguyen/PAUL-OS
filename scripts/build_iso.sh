#!/bin/bash
set -e

echo "[*] Starting PAUL OS build process..."

# Step 1: Clean old builds FIRST
echo "[*] Cleaning old builds and state..."
lb clean

# Step 2: Initialize live-build configuration
echo "[*] Initializing live-build..."
lb config -d testing --apt-recommends false --apt-indices false --apt-options "--no-install-recommends" --bootappend-live "boot=live components quiet init_on_free=1 init_on_alloc=1"

# Step 3: Download and verify cryptographic tools
echo "[*] Fetching and verifying tools..."
./scripts/verify_sparrow.sh
./scripts/verify_bip39.sh
./scripts/verify_electrum.sh

# Step 4: Compile ISO
echo "[*] Compiling ISO..."
lb build

echo "[*] Build complete! Look for paul-os-amd64.hybrid.iso"

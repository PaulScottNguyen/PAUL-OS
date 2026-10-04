#!/bin/bash
set -e

echo "[*] Starting PAUL OS build process..."

# Step 1: Initialize live-build configuration
echo "[*] Initializing live-build..."
lb config

# Step 2: Download and verify Sparrow Wallet
echo "[*] Fetching and verifying Sparrow Wallet..."
./scripts/verify_sparrow.sh

# Step 3: Clean previous builds and compile
echo "[*] Cleaning old builds..."
lb clean --binary

echo "[*] Compiling ISO..."
lb build

echo "[*] Build complete! Look for paul-os-amd64.hybrid.iso"
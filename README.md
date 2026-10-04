# PAUL OS (Partitioned Air-gapped Untraceable Linux)

![License: GNU General Public License version 3](https://img.shields.io/badge/License-GNU_GPL_v3.0-blue)
![Build: Debian Live](https://img.shields.io/badge/Build-Debian%20Live-red.svg)
![Status: Alpha v1.0](https://img.shields.io/badge/Status-Alpha_v1.0-orange.svg)

**PAUL OS** is an amnesic, read-only, air-gapped Live CD environment engineered specifically for secure offline Bitcoin cold storage and PSBT (Partially Signed Bitcoin Transaction) signing. 

By aggressively stripping out networking and storage drivers at the kernel level, PAUL OS guarantees a mathematically sound air-gap. It boots entirely into RAM and utilizes cryptographic memory wiping upon shutdown to prevent cold-boot forensics.

## Threat Model & Defenses

PAUL OS assumes the host hardware is potentially compromised and operates under a zero-trust architecture.

* **Air-Gap Enforcement:** All network drivers (Ethernet, Wi-Fi, Bluetooth) are blacklisted via `modprobe`. The kernel is physically incapable of loading networking modules.
* **Storage Isolation:** Internal SATA, IDE, and NVMe block devices are ignored via strict `udev` rules. The OS cannot read or write to internal host drives.
* **Kernel-Level RAM Amnesia:** Instead of relying on user-space scripts that risk Out-of-Memory (OOM) kernel panics, PAUL OS passes `init_on_free=1` and `slab_nomerge` directly to the bootloader. The Linux kernel natively and instantly overwrites memory pages with zeros the exact microsecond they are freed, neutralizing Cold Boot Attacks without interrupting graceful system shutdowns.
* **PSBT Transport:** Designed for USB-free environments. Transaction data is passed entirely via QR code using the bundled UVC webcam drivers and Sparrow Wallet's optical capabilities.

## Bundled Software

* **Base System:** Debian 13 (Trixie) minimal build with `openbox`.
* **Bitcoin Coordinator:** [Sparrow Wallet](https://sparrowwallet.com/) (v2.5.5)
* **Webcam/QR Utilities:** `zbar-tools`, `guvcview`

## Build Instructions (Reproducible Build)

Do not trust pre-compiled ISOs, including mine. You are encouraged to audit the shell scripts and build the `.iso` yourself on a secure OS.

### Linux (Debian/Ubuntu Native or VM)
1. Install the build dependencies:
   ```bash
   sudo apt update
   sudo apt install live-build git gnupg curl wget -y
2. Execute the automated build wrapper (requires root):
   ```bash
   sudo ./scripts/build_iso.sh
3. The compiler will output paul-os-amd64.hybrid.iso. Burn this image to a standard 700MB CD-R or any form of secondary storage you wish.

### Windows 10/11 (WSL 2)
You cannot build this ISO natively in Windows or on an NTFS drive. You must use the Windows Subsystem for Linux (WSL 2) and build entirely within the Linux file system.
1. Open PowerShell as Administrator and install Debian:
   ```bash
   wsl --install -d Debian
2. Restart your computer and open the new "Debian" app from your Start Menu.
CRITICAL: Ensure you are in your Linux home directory, NOT your mounted Windows C: drive:
   ```bash
   cd ~
Follow steps 1-3 from the Linux instructions above to install dependencies and run the build script.

3. Once the build finishes, open the Windows File Explorer directly to that Linux folder by typing this in the Debian terminal:
   ```bash
   explorer.exe .
Drag and drop paul-os-amd64.hybrid.iso to your Windows Desktop and burn it to a CD-R or any form of secondary storage you wish.

#### Acknowledgements & Credits
- Craig Raw & Sparrow Wallet Contributors: For developing Sparrow Wallet, the premier Bitcoin desktop coordinator.
- The Debian Project: For maintaining the live-build toolchain that makes reproducible amnesic operating systems possible.

#### Disclaimers & Licensing
NO WARRANTY / NOT FINANCIAL ADVICE:
This software is provided "as is", without warranty of any kind, express or implied. The author(s) of PAUL OS are not responsible for any lost funds, hardware damage, or security breaches resulting from the use, misuse, or improper configuration of this software or cold storage techniques. Always test your backup seed phrases and transaction flows on testnet before using mainnet funds.

License:
The build scripts and configurations created for PAUL OS are licensed under the GNU General Public License v3.0 (GPLv3). Anyone is free to audit, modify, and distribute this code, provided any derivative works are also open-source and distributed under the same license.

Third-Party Software: Sparrow Wallet is copyright Craig Raw and licensed under the Apache License 2.0. Debian Linux and its packages are subject to their respective open-source licenses as defined by the Debian Free Software Guidelines (DFSG).

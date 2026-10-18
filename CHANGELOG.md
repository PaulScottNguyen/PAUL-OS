# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-18
### Added
- **Amnesic Auto-Login Architecture:** Implemented `getty@tty1.service.d/override.conf` running `/sbin/agetty --autologin root` to boot directly into a root TTY and spawn Openbox via `.profile` and `.xinitrc`.
- **Physical Network Amputation:** Built `99-physical-shrink.chroot` to aggressively purge all wireless and ethernet kernel modules (`/drivers/net`, `mac80211`, `wireless`), remove unused GPU/networking firmwares, strip man/doc files, and rebuild the initramfs.
- **Early-Boot Tamper Verification:** Introduced `99-tamper-verify` in `initramfs-tools` (`live-bottom`) to compute and display a SHA-256 hash of `/run/live/medium/live/filesystem.squashfs` before X11 initialization.
- **Live-Build Hook Neutralization:** Deployed 24 zero-byte override hooks in `config/hooks/normal/` and `config/hooks/live/` to suppress unnecessary caching (plocate, man-db, python pyc, xapian, dracut).
- **Automated APT Overrides:** Added `config/archives/blacklist-plymouth.pref.chroot` (pin priority -1) to prevent Plymouth installation and injected `99-force-yes` to prevent non-interactive APT prompt freezes.
- **Hardware Wallet Integration:** Embedded upstream `udev` rule profiles for Ledger (`20-hw1.rules`), Coinkite/Coldcard (`51-coinkite.rules`), Trezor (`51-trezor.rules`), KeepKey (`51-usb-keepkey.rules`), BitBox02 (`53-hid-bitbox02.rules`, `54-hid-bitbox02.rules`), and Blockstream Jade (`55-usb-jade.rules`).
- **Cryptographic & Cold Storage Suite:**
  - Automated download, verification, and packaging for Sparrow Wallet (v2.5.5).
  - Automated build-time extraction of Electrum (v4.8.2) AppImage to bypass FUSE requirements.
  - Staged Ian Coleman's standalone BIP39 tool alongside `surf`.
  - Added `dice-to-seed` Python entropy generation utility (99 D6 rolls to 256-bit SHA-256 hex).
  - Added `show-qr` ANSI UTF-8 terminal QR code generator.
- **Peripheral & Hardware Support:** Added `matchbox-keyboard` for on-screen entry, `pcscd` for smart cards, `cups-daemon`/`cups-client`/`ipp-usb` for offline paper backups, and `pcmanfm`/`udisks2` for physical USB PSBT handoffs.
- **Failsafe Permissions Hook:** Built `04-failsafe-permissions.chroot` to automatically assert execution permissions on all custom CLI tools and unpacked wallet binaries.
- **Kernel Memory Poisoning:** Appended `init_on_alloc=1` alongside `init_on_free=1` in `config/binary` boot parameters to guarantee full RAM scrubbing upon allocation and deallocation.

### Changed
- **Sparrow Execution Path:** Fixed Openbox `menu.xml` and permissions hooks to correctly address the case-sensitive binary `/opt/sparrow/bin/Sparrow`.
- **Screen Sleep Prevention:** Configured `.xinitrc` to execute `xset s off`, `xset -dpms`, and `xset s noblank` to permanently stop display power management timeouts during signing sessions.
- **WebKit Sandbox Override:** Configured `.xinitrc` with `export WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS=1` to allow the `surf` browser to execute local HTML derivation tools under the root user.
- **Workspace Lockdown:** Configured `02-openbox-lockdown.chroot` to enforce exactly 1 virtual desktop in `/etc/xdg/openbox/rc.xml`.
- **Compiler Flags:** Unified `scripts/build_iso.sh` and `config/common` to strictly specify `--apt-recommends false` alongside `--apt-options "--no-install-recommends"`.
- **Packaging Modernization:** Updated packaging targets to account for Debian's 64-bit time transition (`libzbar0t64`).

### Removed
- Removed display managers (`lightdm`, `nodm`) to resolve race condition boot hangs.
- Removed user-creation scripts (`01-setup-user.chroot`) and `/etc/skel` configurations in favor of the unified root session.
- Removed deprecated AppArmor kernel bootloader flags and redundant userspace audio/video dependencies (`alsa-utils`, `guvcview`, `xterm`).

## [1.1.0-beta] - 2026-10-11
### Added
- AppArmor Mandatory Access Control (MAC) sandbox profiles for Sparrow Wallet (`opt.sparrow.bin.sparrow`).
- USB Mass Storage lockdown via `udev` rules (`10-block-usb-storage.rules`) to instantly drop authorization for inserted storage devices.
- Deterministic reproducible build configuration (`LB_REPRODUCIBLE="true"`) to guarantee identical SHA256 build hashes across different host machines.
- Custom Openbox right-click menu (`menu.xml`) featuring safe reboot/shutdown confirmation prompts, `xterm` terminal access, and webcam quick-launch.
- Autostart configuration to automatically launch Sparrow Wallet upon X11 initialization.
- Repository-wide `.gitattributes` configuration to enforce Linux `LF` line endings, preventing Windows text editors from breaking compilation scripts.

### Changed
- Fixed a bug in `scripts/verify_sparrow.sh` by updating the download variables to perfectly match Craig Raw's `sparrowwallet` manifest filename, ensuring flawless SHA256 verification.
- Updated `config/binary` bootloader parameters to actively enforce AppArmor at the kernel level (`apparmor=1 security=apparmor`).
- Expanded `package-lists` to include the necessary `apparmor`, `apparmor-utils`, and `xterm` dependencies.
- Migrated from user-space scripts to native kernel-level amnesia (`init_on_free=1` and `slab_nomerge`) to neutralize Cold Boot Attacks without triggering Out-of-Memory (OOM) kernel panics.

## [1.0.0-alpha] - 2026-10-04
### Added
- Initial project release: PAUL OS (Partitioned Air-gapped Untraceable Linux).
- Minimal Debian 13 (Trixie) base environment with Openbox.
- Kernel-level air-gap enforcement via `modprobe` network driver blacklisting.
- Internal SATA, IDE, and NVMe block device isolation via `udev` rules.
- Automated `verify_sparrow.sh` script for fetching and PGP-verifying Sparrow Wallet v2.5.5.
- Base build wrapper scripts (`build_iso.sh`).

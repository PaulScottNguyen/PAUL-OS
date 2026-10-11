# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

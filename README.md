# RHTLC COPR Repository

Public repository for RHTLC (Red Hat Training Lab Connector) Linux releases and RPM packages.

## Overview

This repository contains:
- **Pre-compiled Linux binaries** for RHTLC CLI and GUI
- **RPM spec file** for building RPM packages
- **Desktop integration** files for GNOME/KDE
- **COPR build configuration** for automated RPM builds

## Quick Installation

### Method 1: Install from COPR (Recommended)

```bash
# Enable the COPR repository
sudo dnf copr enable redhattraining/rhtlc

# Install RHTLC
sudo dnf install rhtlc
```

### Method 2: Direct Binary Download

```bash
VERSION="3.4.3"

# Download CLI
curl -L -o rhtlc \
  https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/${VERSION}/rhtlc-linux-x86_64
chmod +x rhtlc
sudo mv rhtlc /usr/local/bin/

# Download GUI
curl -L -o rhtlc-gui \
  https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/${VERSION}/rhtlc-gui-linux-x86_64
chmod +x rhtlc-gui
sudo mv rhtlc-gui /usr/local/bin/
```

### Method 3: Build RPM Locally

See [RPM_BUILD_INSTRUCTIONS.md](RPM_BUILD_INSTRUCTIONS.md) for detailed instructions.

## What is RHTLC?

RHTLC (Red Hat Training Lab Connector) provides command-line and graphical tools for connecting to Red Hat training lab environments via SSH tunnels and SOCKS5 proxies.

### Features

- **CLI Tool** (`rhtlc`) - Command-line interface for scripting and automation
- **GUI Tool** (`rhtlc-gui`) - Graphical interface for interactive use
- **SSH Tunnel Management** - Secure connections to training labs
- **SOCKS5 Proxy Support** - Local proxy for browser and application access
- **Credential Management** - Secure handling of authentication

## Repository Structure

```
rhtlc-copr/
├── README.md                      # This file
├── rhtlc.spec                     # RPM spec file
├── RHTLC-GUI.desktop             # Desktop entry for GUI app
├── RPM_BUILD_INSTRUCTIONS.md     # Detailed build guide
├── Makefile                       # Build automation
├── .copr/
│   └── Makefile                  # COPR build configuration
└── releases/
    ├── README.md
    └── 3.4.3/
        ├── rhtlc-linux-x86_64        # CLI binary
        ├── rhtlc-gui-linux-x86_64    # GUI binary
        └── README.md                  # Version-specific info
```

## System Requirements

- **Operating System**: RHEL/Fedora/AlmaLinux/Rocky Linux 8 or later
- **Architecture**: x86_64
- **glibc**: Version 2.28 or later
- **Python**: 3.8 or later (runtime dependency)
- **Desktop**: Any Linux desktop environment with X11 or Wayland (for GUI)

## Binary Information

All binaries are:
- Built on AlmaLinux 8 for maximum compatibility
- Self-contained with minimal dependencies
- Digitally signed (SHA256 checksums provided)
- Published automatically via GitHub Actions

### Checksums

SHA256 checksums for each release are available in the version-specific README files in the `releases/` directory.

## Using the RPM Package

### Installation

After installing the RPM package:

```bash
# CLI usage
rhtlc --help
rhtlc --version

# GUI usage (from terminal)
rhtlc-gui

# Or launch from Applications menu:
# Internet → RHTLC GUI
```

### Package Contents

The RPM installs:
- Binaries: `/opt/RHTLC/rhtlc`, `/opt/RHTLC/rhtlc-gui`
- Symlinks: `/usr/bin/rhtlc`, `/usr/bin/rhtlc-gui`
- Desktop file: `/usr/share/applications/RHTLC-GUI.desktop`
- Documentation: `/usr/share/doc/RHTLC/README.md`

### Uninstallation

```bash
sudo dnf remove rhtlc
```

## Building RPMs

### For COPR

COPR will automatically use the `.copr/Makefile` to build packages. The Makefile:
1. Extracts version from `rhtlc.spec`
2. Downloads binaries from `releases/{version}/`
3. Builds the SRPM
4. COPR then builds binary RPMs for configured distributions

### Locally

```bash
# Clone this repository
git clone https://github.com/RedHatTraining/rhtlc-copr.git
cd rhtlc-copr

# Build using make
make srpm VERSION=3.4.3

# Or build manually (see RPM_BUILD_INSTRUCTIONS.md)
```

## Publishing New Releases

New releases are automatically published by the GitHub Actions workflow in the main repository:

1. Release is created in [dle-wstunnel-ole](https://github.com/RedHatTraining/dle-wstunnel-ole)
2. Workflow builds Linux binaries
3. Workflow publishes to this repository's `releases/` directory
4. COPR can then build RPMs from the new version

## Desktop Integration

The GUI application integrates with GNOME and KDE desktops:

- **Category**: Internet / Network / Remote Access
- **Name**: RHTLC GUI
- **Launcher**: Available in applications menu
- **Icon**: Custom icon support (to be added)

## TODO / Future Enhancements

- [ ] Add application icon (`.png` or `.svg`)
- [ ] Create icon cache update in RPM post-install
- [ ] Add man pages for CLI
- [ ] Add configuration file examples
- [ ] Create release automation for version bumps
- [ ] Add GPG signing for RPM packages

## Contributing

This is a public mirror repository for binary releases. Source code is in the private repository:
- Source: https://github.com/RedHatTraining/dle-wstunnel-ole (private)
- Issues: Report in this repository's issue tracker

## Support

- **Documentation**: See [RPM_BUILD_INSTRUCTIONS.md](RPM_BUILD_INSTRUCTIONS.md)
- **Issues**: https://github.com/RedHatTraining/rhtlc-copr/issues
- **COPR Project**: https://copr.fedorainfracloud.org/coprs/redhattraining/rhtlc/

## License

MIT License - See source repository for full license text.

## Acknowledgments

Built with:
- Python and PyInstaller
- PyQt5 for GUI
- wstunnel for tunneling
- GitHub Actions for automation
- COPR for RPM distribution

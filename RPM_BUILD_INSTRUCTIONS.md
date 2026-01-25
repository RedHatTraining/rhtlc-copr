# RHTLC RPM Build Instructions

This repository contains the files necessary to build RHTLC RPM packages using COPR (Cool Other Package Repo).

## Repository Contents

### Core Files

- **`rhtlc.spec`** - RPM spec file for building the package
- **`RHTLC-GUI.desktop`** - Desktop entry file for the GUI application
- **`releases/`** - Directory containing versioned binary releases

### Binary Sources

The spec file references binaries from the `releases/` directory:
- `rhtlc-linux-x86_64` - CLI binary
- `rhtlc-gui-linux-x86_64` - GUI binary

These binaries are automatically published by the GitHub Actions workflow from the main repository.

## Building Locally with rpmbuild

### Prerequisites

```bash
# Install rpmbuild tools
sudo dnf install rpm-build rpmdevtools

# Set up RPM build environment
rpmdev-setuptree
```

### Build Steps

1. **Download the binaries** from a release:

```bash
VERSION="3.4.3"
cd ~/rpmbuild/SOURCES/

# Download binaries
curl -L -o rhtlc-linux-x86_64 \
  https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/${VERSION}/rhtlc-linux-x86_64

curl -L -o rhtlc-gui-linux-x86_64 \
  https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/${VERSION}/rhtlc-gui-linux-x86_64

# Download desktop file
curl -L -o RHTLC-GUI.desktop \
  https://github.com/RedHatTraining/rhtlc-copr/raw/main/RHTLC-GUI.desktop
```

2. **Copy the spec file**:

```bash
cp rhtlc.spec ~/rpmbuild/SPECS/
```

3. **Build the RPM**:

```bash
cd ~/rpmbuild/SPECS/
rpmbuild -ba rhtlc.spec
```

4. **Find the built RPM**:

```bash
ls -lh ~/rpmbuild/RPMS/x86_64/rhtlc-*.rpm
ls -lh ~/rpmbuild/SRPMS/rhtlc-*.src.rpm
```

## Installing the RPM

```bash
sudo dnf install ~/rpmbuild/RPMS/x86_64/rhtlc-3.4.3-1.x86_64.rpm
```

Or:

```bash
sudo rpm -ivh ~/rpmbuild/RPMS/x86_64/rhtlc-3.4.3-1.x86_64.rpm
```

## Building with COPR

### Setting Up COPR

1. **Create a COPR account** at https://copr.fedorainfracloud.org/

2. **Install COPR CLI**:

```bash
sudo dnf install copr-cli
```

3. **Configure API token**:

Get your API token from: https://copr.fedorainfracloud.org/api/

Save it to `~/.config/copr`:

```ini
[copr-cli]
username = your-username
login = your-fedora-login
token = your-api-token
copr_url = https://copr.fedorainfracloud.org
```

### Create COPR Project

```bash
copr-cli create rhtlc \
  --chroot fedora-39-x86_64 \
  --chroot fedora-40-x86_64 \
  --chroot epel-8-x86_64 \
  --chroot epel-9-x86_64 \
  --description "Red Hat Training Lab Connector - CLI and GUI tools"
```

### Build from Git

Option 1: Build from this repository:

```bash
copr-cli buildscm rhtlc \
  --clone-url https://github.com/RedHatTraining/rhtlc-copr.git \
  --method make \
  --spec rhtlc.spec
```

Option 2: Build from uploaded SRPM:

```bash
# First create SRPM locally
rpmbuild -bs ~/rpmbuild/SPECS/rhtlc.spec

# Then upload to COPR
copr-cli build rhtlc ~/rpmbuild/SRPMS/rhtlc-3.4.3-1.src.rpm
```

### Monitor Build

```bash
copr-cli status rhtlc
```

### Get Repository Information

```bash
copr-cli get rhtlc
```

## Installing from COPR

Once the package is built in COPR:

```bash
# Enable the COPR repository
sudo dnf copr enable your-username/rhtlc

# Install the package
sudo dnf install rhtlc

# Or update existing installation
sudo dnf upgrade rhtlc
```

## Manual Installation (without RPM)

If you prefer not to use RPM:

```bash
# Download binaries
VERSION="3.4.3"
curl -L -o /tmp/rhtlc \
  https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/${VERSION}/rhtlc-linux-x86_64

curl -L -o /tmp/rhtlc-gui \
  https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/${VERSION}/rhtlc-gui-linux-x86_64

# Install
chmod +x /tmp/rhtlc /tmp/rhtlc-gui
sudo mv /tmp/rhtlc /tmp/rhtlc-gui /usr/local/bin/

# Verify
rhtlc --version
```

## Package Contents

After installation, the RPM provides:

### Binaries
- `/opt/RHTLC/rhtlc` - CLI application
- `/opt/RHTLC/rhtlc-gui` - GUI application
- `/usr/bin/rhtlc` - Symlink to CLI
- `/usr/bin/rhtlc-gui` - Symlink to GUI

### Desktop Integration
- `/usr/share/applications/RHTLC-GUI.desktop` - Desktop entry
- Desktop menu: Internet → RHTLC GUI

### Documentation
- `/usr/share/doc/RHTLC/README.md` - Basic documentation

## Updating the Version

To update to a new version:

1. Update `%define version` in `rhtlc.spec`
2. Update the `%changelog` section
3. Download new binaries from the corresponding release
4. Rebuild the RPM

## System Requirements

- RHEL/Fedora/AlmaLinux/Rocky Linux 8 or later
- glibc 2.28 or later
- x86_64 architecture
- Python 3.8 or later

## Troubleshooting

### Missing Dependencies

If you get dependency errors:

```bash
sudo dnf install python3
```

### Binary Not Executable

```bash
chmod +x /opt/RHTLC/rhtlc /opt/RHTLC/rhtlc-gui
```

### Desktop File Not Appearing

Update desktop database:

```bash
sudo update-desktop-database /usr/share/applications/
```

## Support

- GitHub Issues: https://github.com/RedHatTraining/rhtlc-copr/issues
- Source Repository: https://github.com/RedHatTraining/dle-wstunnel-ole (private)
- Binary Repository: https://github.com/RedHatTraining/rhtlc-copr

## License

MIT License - See source repository for details

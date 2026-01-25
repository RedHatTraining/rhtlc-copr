# Getting Started with RHTLC COPR Package

## What Was Just Created

Your rhtlc-copr repository now has everything needed to build and distribute RPM packages:

### ✅ Core RPM Files

1. **`rhtlc.spec`** - Complete RPM specification file
   - Installs CLI and GUI binaries
   - Creates symlinks in /usr/bin
   - Installs desktop integration
   - Includes documentation

2. **`RHTLC-GUI.desktop`** - Desktop entry file
   - Category: Internet / Network / Remote Access
   - GNOME-compliant
   - Ready for GUI launcher integration

### ✅ Build Automation

3. **`Makefile`** - Standard build automation
   - Downloads binaries from releases/
   - Prepares sources for RPM build
   - Creates SRPM packages

4. **`.copr/Makefile`** - COPR-specific build
   - Automatically used by COPR build system
   - Downloads from GitHub releases
   - Builds SRPM for COPR

### ✅ Documentation

5. **`README.md`** - Comprehensive repository documentation
6. **`RPM_BUILD_INSTRUCTIONS.md`** - Detailed build guide
7. **`ICON_REQUIREMENTS.md`** - Icon specifications and guide
8. **`GETTING_STARTED.md`** - This file

## Repository Structure Now

```
rhtlc-copr/
├── README.md                          # Main documentation
├── GETTING_STARTED.md                 # Quick start guide
├── RPM_BUILD_INSTRUCTIONS.md          # Build instructions
├── ICON_REQUIREMENTS.md               # Icon guide
├── rhtlc.spec                         # RPM spec file
├── RHTLC-GUI.desktop                  # Desktop entry
├── Makefile                           # Build automation
├── .copr/
│   └── Makefile                       # COPR build config
└── releases/
    ├── README.md
    └── 3.4.3/
        ├── README.md
        ├── rhtlc-linux-x86_64
        └── rhtlc-gui-linux-x86_64
```

## Quick Start: Build Your First RPM

### Option 1: Local Build (Testing)

```bash
# 1. Clone the repository
git clone https://github.com/RedHatTraining/rhtlc-copr.git
cd rhtlc-copr

# 2. Install build tools
sudo dnf install rpm-build rpmdevtools make

# 3. Set up RPM build environment
rpmdev-setuptree

# 4. Build SRPM
make srpm VERSION=3.4.3

# 5. Build RPM
rpmbuild --rebuild *.src.rpm

# 6. Install
sudo dnf install ~/rpmbuild/RPMS/x86_64/rhtlc-*.rpm

# 7. Test
rhtlc --version
rhtlc-gui
```

### Option 2: COPR Build (Distribution)

```bash
# 1. Install COPR CLI
sudo dnf install copr-cli

# 2. Configure your COPR API token
# Get token from: https://copr.fedorainfracloud.org/api/
mkdir -p ~/.config
cat > ~/.config/copr <<EOF
[copr-cli]
username = your-username
login = your-fedora-login
token = your-api-token
copr_url = https://copr.fedorainfracloud.org
EOF

# 3. Create COPR project
copr-cli create rhtlc \
  --chroot fedora-39-x86_64 \
  --chroot fedora-40-x86_64 \
  --chroot epel-8-x86_64 \
  --chroot epel-9-x86_64 \
  --description "Red Hat Training Lab Connector"

# 4. Build from Git
copr-cli buildscm rhtlc \
  --clone-url https://github.com/RedHatTraining/rhtlc-copr.git \
  --type git \
  --method make

# 5. Monitor build
copr-cli monitor rhtlc
```

## Next Steps

### 1. Test the Package Locally

```bash
# Build and install locally
make srpm VERSION=3.4.3
rpmbuild --rebuild *.src.rpm
sudo dnf install ~/rpmbuild/RPMS/x86_64/rhtlc-*.rpm

# Test CLI
rhtlc --help
rhtlc --version

# Test GUI
rhtlc-gui

# Check desktop integration
ls -l /usr/share/applications/RHTLC-GUI.desktop
desktop-file-validate /usr/share/applications/RHTLC-GUI.desktop

# Verify files
rpm -ql rhtlc
```

### 2. Add an Icon (Optional but Recommended)

See [ICON_REQUIREMENTS.md](ICON_REQUIREMENTS.md) for:
- Icon specifications
- Design guidelines
- Installation instructions
- How to update the spec file

### 3. Commit to Repository

```bash
git add .
git commit -m "Add RPM build infrastructure

- Add rhtlc.spec for RPM packaging
- Add RHTLC-GUI.desktop for desktop integration
- Add Makefile for build automation
- Add .copr/Makefile for COPR builds
- Add comprehensive documentation"

git push origin main
```

### 4. Set Up COPR (For Public Distribution)

1. **Create COPR account**: https://copr.fedorainfracloud.org/
2. **Create project**: Use copr-cli or web interface
3. **Trigger build**: Push to Git or upload SRPM
4. **Share repository**: Give users installation instructions

### 5. Update Version for New Releases

When a new version is released:

```bash
# 1. Edit rhtlc.spec
#    - Update %define version line
#    - Add entry to %changelog

# 2. Commit changes
git add rhtlc.spec
git commit -m "Update to version 3.4.4"
git push

# 3. Trigger COPR rebuild (if using auto-rebuild)
#    Or manually trigger via copr-cli
```

## Testing Checklist

Before distributing:

- [ ] RPM builds successfully
- [ ] RPM installs without errors
- [ ] CLI binary works: `rhtlc --version`
- [ ] GUI binary launches: `rhtlc-gui`
- [ ] Desktop file is valid: `desktop-file-validate RHTLC-GUI.desktop`
- [ ] GUI appears in application menu (Internet category)
- [ ] Symlinks work: `/usr/bin/rhtlc` and `/usr/bin/rhtlc-gui`
- [ ] Documentation is installed: `/usr/share/doc/RHTLC/README.md`
- [ ] RPM uninstalls cleanly: `sudo dnf remove rhtlc`

## Common Issues and Solutions

### Issue: Binary not found

**Error**: `Source0: rhtlc-linux-x86_64 not found`

**Solution**: Ensure binaries exist in releases/VERSION/ directory or run `make sources`

### Issue: Desktop file validation fails

**Error**: `desktop-file-validate` shows errors

**Solution**: Check RHTLC-GUI.desktop for syntax errors, especially:
- Exec path is correct
- Categories are valid
- No trailing spaces

### Issue: COPR build fails

**Error**: Build fails in COPR

**Solution**:
1. Check COPR build logs
2. Verify .copr/Makefile syntax
3. Ensure binaries are accessible from GitHub
4. Test local SRPM build first

### Issue: Icon not showing

**Error**: GUI launches but no icon in menu

**Solution**:
1. Add icon file (see ICON_REQUIREMENTS.md)
2. Update rhtlc.spec
3. Rebuild RPM
4. Run `gtk-update-icon-cache`

## Support and Resources

### Documentation

- **Build Instructions**: [RPM_BUILD_INSTRUCTIONS.md](RPM_BUILD_INSTRUCTIONS.md)
- **Icon Guide**: [ICON_REQUIREMENTS.md](ICON_REQUIREMENTS.md)
- **Main README**: [README.md](README.md)

### External Resources

- **COPR Documentation**: https://docs.pagure.org/copr.copr/
- **RPM Packaging Guide**: https://rpm-packaging-guide.github.io/
- **Desktop Entry Spec**: https://specifications.freedesktop.org/desktop-entry-spec/
- **Fedora Packaging Guidelines**: https://docs.fedoraproject.org/en-US/packaging-guidelines/

### Getting Help

- **Repository Issues**: https://github.com/RedHatTraining/rhtlc-copr/issues
- **COPR Support**: https://pagure.io/copr/copr/issues
- **Fedora Packaging**: #fedora-devel on Libera.Chat

## Quick Command Reference

```bash
# Local RPM build
make srpm VERSION=3.4.3
rpmbuild --rebuild *.src.rpm

# Install locally
sudo dnf install ~/rpmbuild/RPMS/x86_64/rhtlc-*.rpm

# COPR build
copr-cli build rhtlc *.src.rpm

# Test installation
rhtlc --version
rhtlc-gui

# Uninstall
sudo dnf remove rhtlc

# Clean build artifacts
make clean
```

## What's Next?

1. ✅ You have a complete RPM package setup
2. ✅ You have COPR build automation
3. ✅ You have desktop integration
4. 🔲 Add an application icon (optional)
5. 🔲 Test the package thoroughly
6. 🔲 Set up COPR for public distribution
7. 🔲 Share installation instructions with users

## Success!

Your RHTLC package is ready to build and distribute! 🎉

Start with a local test build, then move to COPR for wider distribution.

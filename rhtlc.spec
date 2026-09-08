%define name rhtlc
%define version 6.0.1
%define release 1
%define buildroot %{_tmppath}/%{name}-%{version}-%{release}-root

Summary: Red Hat Training Lab Connector - CLI and GUI tools
Name: %{name}
Version: %{version}
Release: %{release}
License: MIT
Group: Applications/Internet
BuildRoot: %{buildroot}
AutoReqProv: no
URL: https://github.com/RedHatTraining/rhtlc-copr
# All four onedir archives ship in the SRPM unconditionally. COPR builds the SRPM
# once and reuses it for every chroot — do NOT use ifarch conditionals on SourceN.
Source0: rhtlc-linux-x86_64.tar.gz
Source1: rhtlc-gui-linux-x86_64.tar.gz
Source2: rhtlc-linux-arm64.tar.gz
Source3: rhtlc-gui-linux-arm64.tar.gz
Source4: RHTLC-GUI.desktop
Source5: RHTLC-Logo.jpeg

Requires: python3 >= 3.8

%description
RHTLC (Red Hat Training Lab Connector) provides command-line and graphical 
tools for connecting to Red Hat training lab environments via SSH tunnels 
and SOCKS5 proxies.

Features:
- CLI tool for scripting and automation
- GUI application for interactive use
- SSH tunnel management
- SOCKS5 proxy support
- Secure credential handling

This package includes both the CLI (rhtlc) and GUI (rhtlc-gui) applications.

%prep
# Create the build directory, then extract all four onedir archives into it
%setup -q -T -c -n %{name}-%{version}
tar -xzf %{_sourcedir}/rhtlc-linux-x86_64.tar.gz
tar -xzf %{_sourcedir}/rhtlc-gui-linux-x86_64.tar.gz
tar -xzf %{_sourcedir}/rhtlc-linux-arm64.tar.gz
tar -xzf %{_sourcedir}/rhtlc-gui-linux-arm64.tar.gz

%build
# No compile — PyInstaller onedir trees are pre-built

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/RHTLC/rhtlc
mkdir -p $RPM_BUILD_ROOT/opt/RHTLC/rhtlc-gui
mkdir -p $RPM_BUILD_ROOT/usr/bin
mkdir -p $RPM_BUILD_ROOT/usr/share/applications
mkdir -p $RPM_BUILD_ROOT/usr/share/doc/RHTLC

# Arch selection runs per-chroot — pick the matching onedir pair here
# (EPEL/RHEL rpmparse treats percent-macros even inside comments — avoid them here)
%ifarch aarch64
cp -a rhtlc-linux-arm64/. $RPM_BUILD_ROOT/opt/RHTLC/rhtlc/
cp -a rhtlc-gui-linux-arm64/. $RPM_BUILD_ROOT/opt/RHTLC/rhtlc-gui/
ln -s /opt/RHTLC/rhtlc/rhtlc-linux-arm64 $RPM_BUILD_ROOT/usr/bin/rhtlc
ln -s /opt/RHTLC/rhtlc-gui/rhtlc-gui-linux-arm64 $RPM_BUILD_ROOT/usr/bin/rhtlc-gui
chmod 0755 $RPM_BUILD_ROOT/opt/RHTLC/rhtlc/rhtlc-linux-arm64
chmod 0755 $RPM_BUILD_ROOT/opt/RHTLC/rhtlc-gui/rhtlc-gui-linux-arm64
%else
cp -a rhtlc-linux-x86_64/. $RPM_BUILD_ROOT/opt/RHTLC/rhtlc/
cp -a rhtlc-gui-linux-x86_64/. $RPM_BUILD_ROOT/opt/RHTLC/rhtlc-gui/
ln -s /opt/RHTLC/rhtlc/rhtlc-linux-x86_64 $RPM_BUILD_ROOT/usr/bin/rhtlc
ln -s /opt/RHTLC/rhtlc-gui/rhtlc-gui-linux-x86_64 $RPM_BUILD_ROOT/usr/bin/rhtlc-gui
chmod 0755 $RPM_BUILD_ROOT/opt/RHTLC/rhtlc/rhtlc-linux-x86_64
chmod 0755 $RPM_BUILD_ROOT/opt/RHTLC/rhtlc-gui/rhtlc-gui-linux-x86_64
%endif

chmod 0755 $RPM_BUILD_ROOT/opt/RHTLC/rhtlc/_internal/rhtlc-wstunnel
chmod 0755 $RPM_BUILD_ROOT/opt/RHTLC/rhtlc-gui/_internal/rhtlc-wstunnel
if [ -d $RPM_BUILD_ROOT/opt/RHTLC/rhtlc-gui/_internal/cli ]; then
    find $RPM_BUILD_ROOT/opt/RHTLC/rhtlc-gui/_internal/cli \
        \( -name 'rhtlc-linux-*' -o -name 'rhtlc-wstunnel' \) \
        -type f -exec chmod 0755 {} \;
fi

cp -p %{_sourcedir}/RHTLC-GUI.desktop $RPM_BUILD_ROOT/usr/share/applications/
cp -p %{_sourcedir}/RHTLC-Logo.jpeg $RPM_BUILD_ROOT/opt/RHTLC/RHTLC-Logo.jpeg

# Create basic documentation
cat > $RPM_BUILD_ROOT/usr/share/doc/RHTLC/README.md << 'EOF'
# RHTLC - Red Hat Training Lab Connector

## Command Line Interface (CLI)

Usage:
```bash
rhtlc --help
rhtlc --version
```

## Graphical User Interface (GUI)

Launch from applications menu or command line:
```bash
rhtlc-gui
```

## Installation Directories

- Onedir bundles: /opt/RHTLC/rhtlc/ and /opt/RHTLC/rhtlc-gui/
- Icon: /opt/RHTLC/RHTLC-Logo.jpeg
- Symlinks: /usr/bin/rhtlc, /usr/bin/rhtlc-gui
- Desktop file: /usr/share/applications/RHTLC-GUI.desktop
- Documentation: /usr/share/doc/RHTLC/

## System Requirements

- RHEL/Fedora/AlmaLinux/Rocky Linux 8 or later
- glibc 2.28 or later
- x86_64 or aarch64 architecture
- Python 3.8 or later

## Source Repository

https://github.com/RedHatTraining/dle-wstunnel-ole (private)

## Support

GitHub: https://github.com/RedHatTraining/rhtlc-copr
EOF

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%dir /opt/RHTLC
/opt/RHTLC/rhtlc/
/opt/RHTLC/rhtlc-gui/
%attr(0644,root,root) /opt/RHTLC/RHTLC-Logo.jpeg
%attr(0644,root,root) /usr/share/applications/RHTLC-GUI.desktop
%doc /usr/share/doc/RHTLC/README.md
/usr/bin/rhtlc
/usr/bin/rhtlc-gui

%post
# Update desktop database if available
if [ -x /usr/bin/update-desktop-database ]; then
    /usr/bin/update-desktop-database -q /usr/share/applications || :
fi

%postun
# Update desktop database after removal
if [ $1 -eq 0 ]; then
    if [ -x /usr/bin/update-desktop-database ]; then
        /usr/bin/update-desktop-database -q /usr/share/applications || :
    fi
fi

%changelog
* Tue Sep 08 2026 RHTLC Build <travis@michettetech.com> - 6.0.1-1
- Install PyInstaller onedir trees from tar.gz sources (CLI+GUI, x86_64 and arm64)
- PATH still exposes rhtlc and rhtlc-gui via /usr/bin symlinks

* Wed Jul 15 2026 RHTLC Build <travis@michettetech.com> - 5.1.0-4
- Remove bare percent-macros from comments (EPEL/RHEL parse them; caused second install section)
- Multi-arch: ship x86_64 and aarch64 (arm64) binaries in one SRPM
- Install section selects the matching binary pair per COPR chroot via ifarch
- Compatible with Fedora/EPEL x86_64 and aarch64 chroots

* Wed Jul 15 2026 RHTLC Build <travis@michettetech.com> - 5.1.0-3
- Escape percent-macros in changelog for EPEL/RHEL rpmparse
- Multi-arch: ship x86_64 and aarch64 (arm64) binaries in one SRPM
- Compatible with Fedora/EPEL x86_64 and aarch64 chroots

* Wed Jul 15 2026 RHTLC Build <travis@michettetech.com> - 5.1.0-2
- Multi-arch: ship x86_64 and aarch64 (arm64) binaries in one SRPM
- Compatible with Fedora/EPEL x86_64 and aarch64 chroots

* Sat Jan 25 2025 RHTLC Build <travis@michettetech.com> - 3.4.3-1
- Initial RPM package for RHTLC
- Includes CLI tool (rhtlc) for command-line operations
- Includes GUI tool (rhtlc-gui) for interactive use
- Built from binaries in rhtlc-copr repository
- Compatible with RHEL 8+ and derivatives
- Provides SSH tunnel management and SOCKS5 proxy support

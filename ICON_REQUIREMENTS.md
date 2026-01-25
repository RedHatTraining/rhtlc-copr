# Icon Requirements for RHTLC

## Current Status

❌ **No icon currently included**

The RHTLC package currently uses a fallback icon. To add a proper application icon, follow this guide.

## Required Icon Files

### Primary Icon

Create an icon file named `rhtlc-icon.png` with the following specifications:

- **Format**: PNG (preferred) or SVG
- **Minimum Size**: 48x48 pixels
- **Recommended Sizes**: 48x48, 64x64, 128x128, 256x256
- **Transparency**: Yes (alpha channel)
- **Colors**: Full color

### Additional Sizes (Optional but Recommended)

For better desktop integration across different display densities:

```
rhtlc-icon-16x16.png
rhtlc-icon-22x22.png
rhtlc-icon-32x32.png
rhtlc-icon-48x48.png
rhtlc-icon-64x64.png
rhtlc-icon-128x128.png
rhtlc-icon-256x256.png
```

Or use SVG (scalable):
```
rhtlc-icon.svg
```

## Installation Locations

Icons should be installed to:

### System-wide Installation
```
/usr/share/icons/hicolor/48x48/apps/rhtlc.png
/usr/share/icons/hicolor/64x64/apps/rhtlc.png
/usr/share/icons/hicolor/128x128/apps/rhtlc.png
/usr/share/icons/hicolor/scalable/apps/rhtlc.svg
```

### RPM Package Structure
```
$RPM_BUILD_ROOT/usr/share/icons/hicolor/48x48/apps/rhtlc.png
$RPM_BUILD_ROOT/usr/share/icons/hicolor/64x64/apps/rhtlc.png
```

## Design Guidelines

### Recommended Theme

- **Subject**: Network connection, tunnel, or training/education related
- **Style**: Modern, flat design preferred
- **Colors**: Red Hat brand colors (optional)
  - Primary: #EE0000 (Red Hat Red)
  - Secondary: #000000 (Black)
  - Accent: Various shades

### Icon Concepts

Consider these concepts:
1. **Network/Tunnel**: Pipeline or tunnel connecting points
2. **SSH Key**: Stylized key with network elements
3. **Training**: Graduation cap with network connection
4. **Portal**: Door or gateway with network symbols
5. **Combined**: Laptop/computer with connection arrows

### Examples from Similar Apps

- SSH clients: Often use terminal + key imagery
- VPN clients: Often use shield + network imagery
- Remote desktop: Often use monitor + connection imagery

## Adding Icon to Repository

1. **Create or obtain the icon file(s)**

2. **Add to repository**:
   ```bash
   # Place icon in repository root
   cp /path/to/icon/rhtlc-icon.png /path/to/rhtlc-copr/
   
   # Or create icons directory
   mkdir -p icons/
   cp /path/to/icons/* icons/
   ```

3. **Update `rhtlc.spec`**:
   
   Uncomment these lines in the spec file:
   
   ```spec
   # In %description section:
   Source3: rhtlc-icon.png
   
   # In %install section:
   mkdir -p $RPM_BUILD_ROOT/usr/share/icons/hicolor/48x48/apps
   cp -p %{_sourcedir}/rhtlc-icon.png $RPM_BUILD_ROOT/usr/share/icons/hicolor/48x48/apps/rhtlc.png
   
   # In %files section:
   /usr/share/icons/hicolor/48x48/apps/rhtlc.png
   
   # In %post section:
   if [ -x /usr/bin/gtk-update-icon-cache ]; then
       /usr/bin/gtk-update-icon-cache -q /usr/share/icons/hicolor || :
   fi
   
   # In %postun section:
   if [ -x /usr/bin/gtk-update-icon-cache ]; then
       /usr/bin/gtk-update-icon-cache -q /usr/share/icons/hicolor || :
   fi
   ```

4. **Update `RHTLC-GUI.desktop`**:
   
   The desktop file already references `Icon=rhtlc`, which will work once the icon is installed.

5. **Test the icon**:
   ```bash
   # After RPM installation
   gtk-update-icon-cache /usr/share/icons/hicolor/
   
   # Verify icon is found
   ls /usr/share/icons/hicolor/48x48/apps/rhtlc.png
   
   # Check desktop file
   desktop-file-validate /usr/share/applications/RHTLC-GUI.desktop
   ```

## Creating Icons

### Using GIMP

1. Open GIMP
2. Create new image: 256x256 pixels
3. Design icon with transparent background
4. Export as PNG
5. Scale to other sizes: Image → Scale Image

### Using Inkscape (for SVG)

1. Open Inkscape
2. Create new document: 256x256px
3. Design vector icon
4. Save as SVG
5. Export PNG at various sizes: File → Export PNG

### Using ImageMagick (for resizing)

```bash
# Resize master icon to multiple sizes
convert rhtlc-icon.png -resize 48x48 rhtlc-icon-48x48.png
convert rhtlc-icon.png -resize 64x64 rhtlc-icon-64x64.png
convert rhtlc-icon.png -resize 128x128 rhtlc-icon-128x128.png
```

## Online Icon Resources

### Free Icon Sources
- **Iconify**: https://icon-sets.iconify.design/
- **Font Awesome**: https://fontawesome.com/icons (check license)
- **Material Icons**: https://fonts.google.com/icons
- **Flaticon**: https://www.flaticon.com/ (attribution may be required)

### Custom Icon Creation Services
- **Fiverr**: Commission a custom icon
- **99designs**: Icon design contests
- **Upwork**: Hire a designer

## Verification Checklist

After adding an icon:

- [ ] Icon file(s) added to repository
- [ ] `rhtlc.spec` updated with Source3
- [ ] Install paths added to spec file
- [ ] %post script uncommented for icon cache
- [ ] %postun script uncommented
- [ ] Desktop file icon reference verified (`Icon=rhtlc`)
- [ ] RPM builds successfully
- [ ] Icon appears in application menu after installation
- [ ] Icon displays correctly in file manager
- [ ] Icon visible in alt-tab switcher

## Temporary Workaround

Until an icon is added, the desktop entry will use the system's fallback icon for network applications. The application will still function normally.

## Questions?

For questions about icon requirements or submission, open an issue in the repository:
https://github.com/RedHatTraining/rhtlc-copr/issues

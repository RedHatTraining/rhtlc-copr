# Fixing COPR Build Configuration

## Problem

The COPR build is failing with:
```
error: Bad file: /var/lib/copr-rpmbuild/results/rhtlc-linux-x86_64: No such file or directory
error: Bad file: /var/lib/copr-rpmbuild/results/rhtlc-gui-linux-x86_64: No such file or directory
```

**Root Cause**: COPR is using `rpkg` as the build method, which expects source files to be present in Git or a lookaside cache. Our binaries need to be downloaded from the `releases/` directory during the build.

**Solution**: Change COPR to use `make` as the build method, which will use our Makefile to download binaries.

## Quick Fix via COPR Web Interface

### Option 1: Update Existing Project (Recommended)

1. **Go to your COPR project**:
   - URL: https://copr.fedorainfracloud.org/coprs/tmichett/RHTLC/

2. **Click "Settings" tab**

3. **Edit the package**:
   - Find your package in the packages list
   - Click "Edit" or "Edit package"

4. **Change SCM settings**:
   - **SCM type**: Git
   - **Clone URL**: `https://github.com/RedHatTraining/rhtlc-copr.git`
   - **Subdirectory**: (leave empty)
   - **Spec file**: `rhtlc.spec`
   - **SRPM build method**: **Change from `rpkg` to `make`** ← This is the key change!

5. **Save** and **rebuild**

### Option 2: Delete and Recreate Package

If editing doesn't work:

1. **Delete the existing package** in COPR web interface

2. **Add a new package** with correct settings:
   - Package name: `rhtlc`
   - SCM type: `Git`
   - Clone URL: `https://github.com/RedHatTraining/rhtlc-copr.git`
   - Spec file: `rhtlc.spec`
   - **SRPM build method**: `make` (not rpkg)

3. **Build** the package

## Fix via COPR CLI

### Update Package Settings

```bash
# Install copr-cli if not already installed
sudo dnf install copr-cli

# Edit package to use make instead of rpkg
copr-cli edit-package-scm rhtlc \
  --clone-url https://github.com/RedHatTraining/rhtlc-copr.git \
  --commit main \
  --spec rhtlc.spec \
  --type git \
  --method make

# Trigger a new build
copr-cli build-package rhtlc --name rhtlc
```

### Or Recreate from Scratch

```bash
# Remove the old package (if needed)
copr-cli delete-package rhtlc --name rhtlc

# Add package with correct configuration
copr-cli add-package-scm rhtlc \
  --clone-url https://github.com/RedHatTraining/rhtlc-copr.git \
  --commit main \
  --spec rhtlc.spec \
  --type git \
  --method make \
  --name rhtlc

# Build
copr-cli build-package rhtlc --name rhtlc
```

## What the Fix Does

### Before (rpkg method):
```
COPR → clones repo → runs rpkg srpm
                   → looks for Source0, Source1 in git
                   → FAILS (files not in git)
```

### After (make method):
```
COPR → clones repo → runs make srpm
                   → Makefile downloads binaries from GitHub
                   → rpmbuild -bs with downloaded files
                   → SUCCESS
```

## Verify the Fix

After changing to `make` method, the COPR build should:

1. **Clone the repository** ✅
2. **Run `make srpm`** ✅
3. **Download binaries** from releases/3.4.3/ ✅
4. **Build SRPM** successfully ✅
5. **Build RPMs** for all configured chroots ✅

Check the build log for:
```
Downloading CLI binary...
Downloading GUI binary...
Downloaded files:
-rwxr-xr-x 1 copr copr 12345678 Jan 25 12:34 rhtlc-linux-x86_64
-rwxr-xr-x 1 copr copr 23456789 Jan 25 12:34 rhtlc-gui-linux-x86_64
Building SRPM with rpmbuild...
Wrote: /var/lib/copr-rpmbuild/results/rhtlc-3.4.3-1.src.rpm
```

## Alternative: Use Direct SRPM Upload

If you can't change the package settings or prefer not to use Git builds:

### Build SRPM Locally

```bash
cd /path/to/rhtlc-copr
make srpm VERSION=3.4.3
```

### Upload to COPR

```bash
copr-cli build RHTLC rhtlc-3.4.3-1.src.rpm
```

This bypasses the Git SCM entirely and uploads a pre-built SRPM.

## Test Locally First

Before fixing COPR, test that the Makefile works:

```bash
cd /Users/travis/Github/rhtlc-copr

# Clean previous attempts
make clean

# Test the srpm target
make srpm

# You should see:
# - Binaries downloading
# - SRPM being built
# - Success message

# Verify SRPM was created
ls -lh *.src.rpm

# Test building the RPM from SRPM
rpmbuild --rebuild rhtlc-*.src.rpm
```

## Understanding the Build Methods

### rpkg (what COPR is currently using)
- Used for Fedora/CentOS packages
- Expects sources in Git or lookaside cache
- Doesn't run custom download scripts
- **Doesn't work for our use case**

### make (what we need)
- Runs `make srpm` target
- Can download files during build
- Flexible and scriptable
- **Perfect for our use case**

### tito
- Fedora packaging tool
- Requires .tito directory
- Not needed for our case

## Files That Enable the Fix

These files in the repository make the `make` method work:

1. **`Makefile`** (root directory)
   - Contains `srpm` target
   - Downloads binaries from releases/
   - Builds SRPM with rpmbuild

2. **`.copr/Makefile`** (alternative location)
   - Backup Makefile for COPR
   - Same functionality as root Makefile

3. **`rhtlc.spec`**
   - References Source0 and Source1
   - Expects files in _sourcedir

## Common Issues After Fix

### Issue: Still fails to download

**Error**: `curl: (22) The requested URL returned error: 404`

**Solution**: Verify the version in releases/
```bash
# Check what versions exist
ls releases/

# Update spec file version if needed
# Or ensure releases/3.4.3/ exists with binaries
```

### Issue: Wrong version being built

**Error**: Downloads old version

**Solution**: Update `%define version` in `rhtlc.spec`

### Issue: COPR doesn't see the changes

**Solution**: 
1. Commit and push changes to GitHub
2. Trigger a new build in COPR
3. Make sure COPR is pulling from main branch

## Next Steps After Fix

1. ✅ Change COPR build method to `make`
2. ✅ Commit these changes to Git (if not already)
3. ✅ Push to GitHub
4. ✅ Trigger new COPR build
5. ✅ Verify build succeeds
6. ✅ Test installation from COPR repo

## Summary

**The fix is simple**: Change the COPR build method from `rpkg` to `make`.

**Where to do it**: COPR web interface → Project Settings → Edit Package → SRPM Build Method → `make`

**Why it works**: The `make` method runs our Makefile which downloads the binaries from GitHub before building the SRPM.

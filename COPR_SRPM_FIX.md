# COPR SRPM Output Directory Fix

## Current Issue

```
Copr build error: No .src.rpm found at /var/lib/copr-rpmbuild/results
```

## What's Happening

1. ✅ COPR is now using `make` method (good!)
2. ✅ Our `.copr/Makefile` is being called (good!)
3. ✅ Binaries should be downloading (check logs)
4. ❌ SRPM not ending up where COPR expects it

## The Fix

The updated `.copr/Makefile` now:

1. **Handles multiple output directory variables**:
   - `outdir` (what COPR passes)
   - `resultdir` (alternative)
   - Falls back to current directory

2. **Verifies SRPM creation**:
   - Checks if SRPM was built
   - Shows detailed error if not found

3. **Ensures COPR finds it**:
   - Copies SRPM to `/var/lib/copr-rpmbuild/results` if needed
   - This is the hardcoded location COPR checks

## Updated Files

The following files have been updated and need to be committed:

- `.copr/Makefile` - Fixed output directory handling
- `Makefile` - Root makefile also updated

## What to Do Now

### 1. Commit and Push Changes

```bash
cd /Users/travis/Github/rhtlc-copr

git add .copr/Makefile Makefile
git commit -m "Fix COPR SRPM output directory handling

- Handle lowercase 'outdir' parameter from COPR
- Add fallback to resultdir variable
- Copy SRPM to /var/lib/copr-rpmbuild/results explicitly
- Add verbose error checking and debugging output"

git push origin main
```

### 2. Trigger New COPR Build

After pushing, trigger a new build in COPR:

**Via Web Interface**:
1. Go to: https://copr.fedorainfracloud.org/coprs/tmichett/RHTLC/
2. Click on your package
3. Click "Rebuild"

**Via CLI**:
```bash
copr-cli build-package RHTLC --name rhtlc
```

### 3. Check Build Logs

Look for these indicators in the build log:

**Success indicators**:
```
Downloading rhtlc CLI binary from releases/3.4.3/
Downloading rhtlc GUI binary from releases/3.4.3/
Downloaded files:
-rwxr-xr-x ... rhtlc-linux-x86_64
-rwxr-xr-x ... rhtlc-gui-linux-x86_64
Building source RPM...
SRPM created successfully: .../rhtlc-3.4.3-1.src.rpm
Copying SRPM to /var/lib/copr-rpmbuild/results/
SRPM build completed successfully!
```

**If still failing**, look for:
- `ERROR: Failed to download CLI binary` - Binary not in releases/
- `ERROR: No SRPM found` - rpmbuild failed
- `curl: (22) The requested URL returned error: 404` - Wrong version or path

## Alternative: Direct SRPM Upload

If Git builds continue to have issues, build and upload SRPM directly:

### Build Locally

```bash
cd /Users/travis/Github/rhtlc-copr
make srpm VERSION=3.4.3
```

### Upload to COPR

```bash
copr-cli build RHTLC rhtlc-3.4.3-1.src.rpm
```

This bypasses all the Git/Makefile complexity and just uploads a pre-built SRPM.

## Debugging the Build

If the build still fails, check:

### 1. Version Mismatch

```bash
# Check what's in releases/
ls releases/

# Check spec file version
grep "^%define version" rhtlc.spec

# They should match! If releases/3.4.3/ exists, spec should say version 3.4.3
```

### 2. Binary Accessibility

Test if binaries are downloadable:

```bash
VERSION="3.4.3"
curl -I https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/${VERSION}/rhtlc-linux-x86_64

# Should return: HTTP/2 200
# If 404: Binary doesn't exist or path is wrong
```

### 3. Makefile Syntax

Test locally:

```bash
cd /Users/travis/Github/rhtlc-copr
make -f .copr/Makefile srpm outdir=/tmp/test spec=rhtlc.spec

# Should create SRPM in /tmp/test/
ls /tmp/test/*.src.rpm
```

## Understanding COPR's Build Process

```
┌─────────────────────────────────────────────────────────┐
│ COPR Build System                                       │
├─────────────────────────────────────────────────────────┤
│ 1. Clone Git repo                                       │
│ 2. Run: make -f .copr/Makefile srpm outdir=...         │
│ 3. Look for SRPM in /var/lib/copr-rpmbuild/results     │
│ 4. If found: Build RPM                                  │
│ 5. If not found: ERROR (this is where we are)          │
└─────────────────────────────────────────────────────────┘
```

Our fix ensures step 3 succeeds by explicitly copying the SRPM there.

## Files Changed

Summary of changes made to fix this issue:

1. **`.copr/Makefile`**:
   - Added `outdir`, `resultdir`, and `spec` parameter handling
   - Removed `@` from commands for verbose output
   - Added explicit copy to `/var/lib/copr-rpmbuild/results`
   - Added error checking and debugging output

2. **`Makefile`** (root):
   - Updated for consistency
   - Auto-detects version from spec file
   - Better error messages

## Success Criteria

After the fix, you should see:

1. ✅ COPR build starts successfully
2. ✅ Binaries download from GitHub
3. ✅ SRPM is built
4. ✅ SRPM is found by COPR
5. ✅ RPM packages built for all chroots

## Next Steps After Success

Once COPR builds successfully:

1. **Test installation**:
   ```bash
   sudo dnf copr enable tmichett/RHTLC
   sudo dnf install rhtlc
   rhtlc --version
   rhtlc-gui
   ```

2. **Update documentation** with installation instructions

3. **Consider adding**:
   - Application icon
   - Man pages
   - Configuration examples

## Still Having Issues?

If this fix doesn't work:

1. **Check the full build log** in COPR web interface
2. **Look for the specific error** message
3. **Try the direct SRPM upload** method as a workaround
4. **Open an issue** with the build log attached

## Quick Test Before Pushing

Test the Makefile locally first:

```bash
cd /Users/travis/Github/rhtlc-copr

# Clean
rm -f *.src.rpm rhtlc-*-x86_64

# Test the .copr/Makefile
make -f .copr/Makefile srpm outdir=. spec=rhtlc.spec

# Should see:
# - Download messages
# - Binary files created
# - SRPM created
# - Success message

# Verify
ls -lh *.src.rpm
```

If that works locally, it should work in COPR!

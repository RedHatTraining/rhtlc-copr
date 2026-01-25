# COPR Build Fix - Quick Reference

## ❌ Current Problem

```
error: Bad file: rhtlc-linux-x86_64: No such file or directory
error: Bad file: rhtlc-gui-linux-x86_64: No such file or directory
```

## ✅ Solution (2 minutes)

### Via Web Interface (Easiest)

1. Go to: https://copr.fedorainfracloud.org/coprs/tmichett/RHTLC/
2. Click **"Settings"** tab
3. Find your package and click **"Edit"**
4. Change **"SRPM build method"** from `rpkg` to **`make`**
5. Click **"Save"**
6. Click **"Rebuild"**

### Via Command Line

```bash
copr-cli edit-package-scm RHTLC \
  --clone-url https://github.com/RedHatTraining/rhtlc-copr.git \
  --commit main \
  --spec rhtlc.spec \
  --type git \
  --method make

copr-cli build-package RHTLC --name rhtlc
```

## Why This Works

| Method | What It Does | Result |
|--------|--------------|--------|
| **rpkg** (current) | Looks for files in Git | ❌ Files not in Git |
| **make** (needed) | Runs `make srpm` → downloads files | ✅ Works! |

## Test It Locally First

```bash
cd /Users/travis/Github/rhtlc-copr
make clean
make srpm
# Should see: "SRPM build completed!"
ls -lh *.src.rpm
```

## Expected COPR Build Log After Fix

```
Downloading CLI binary...
Downloading GUI binary...
Downloaded files:
-rwxr-xr-x ... rhtlc-linux-x86_64
-rwxr-xr-x ... rhtlc-gui-linux-x86_64
Building SRPM with rpmbuild...
Wrote: .../rhtlc-3.4.3-1.src.rpm
SRPM build completed!
```

## That's It!

The fix is literally changing one dropdown from `rpkg` to `make` in the COPR web interface.

See [COPR_FIX.md](COPR_FIX.md) for detailed explanation and troubleshooting.

# COPR Makefile - automatically used by COPR build system
# This file should be in .copr/Makefile
#
# IMPORTANT: COPR builds the SRPM ONCE per build and reuses it for every
# chroot. Download BOTH x86_64 and arm64 binary pairs unconditionally so
# the SRPM is arch-agnostic. Arch selection happens in rhtlc.spec %install.

# COPR passes variables as lowercase, handle both
outdir ?= .
spec ?= rhtlc.spec
resultdir ?= .

# Use whichever is set
OUTDIR := $(if $(outdir),$(outdir),$(resultdir))

# Extract version from spec file
VERSION := $(shell grep "^%define version" $(spec) 2>/dev/null | awk '{print $$3}')

.PHONY: srpm
srpm:
	set -x
	echo "========================================="
	echo "COPR Build: Preparing RHTLC SRPM"
	echo "Version: $(VERSION)"
	echo "Spec file: $(spec)"
	echo "Output directory: $(OUTDIR)"
	echo "Current directory: $(CURDIR)"
	echo "PWD: $$PWD"
	echo "========================================="
	echo ""
	
	# Download ALL arches unconditionally (SRPM is built once, reused per chroot)
	echo "Downloading rhtlc CLI binary (x86_64) from releases/$(VERSION)/"
	curl -v -f -L -o rhtlc-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-x86_64
	
	echo "Downloading rhtlc GUI binary (x86_64) from releases/$(VERSION)/"
	curl -v -f -L -o rhtlc-gui-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-x86_64

	echo "Downloading rhtlc CLI binary (arm64) from releases/$(VERSION)/"
	curl -v -f -L -o rhtlc-linux-arm64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-arm64
	
	echo "Downloading rhtlc GUI binary (arm64) from releases/$(VERSION)/"
	curl -v -f -L -o rhtlc-gui-linux-arm64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-arm64
	
	# Verify binaries were downloaded
	test -f rhtlc-linux-x86_64 || (echo "ERROR: CLI x86_64 binary not found"; exit 1)
	test -f rhtlc-gui-linux-x86_64 || (echo "ERROR: GUI x86_64 binary not found"; exit 1)
	test -f rhtlc-linux-arm64 || (echo "ERROR: CLI arm64 binary not found"; exit 1)
	test -f rhtlc-gui-linux-arm64 || (echo "ERROR: GUI arm64 binary not found"; exit 1)
	
	echo ""
	echo "Downloaded files:"
	ls -lh rhtlc-linux-x86_64 rhtlc-gui-linux-x86_64 rhtlc-linux-arm64 rhtlc-gui-linux-arm64
	echo ""
	
	# Create output directory if it doesn't exist
	mkdir -p $(OUTDIR)
	
	# Build SRPM
	echo "Building source RPM..."
	echo "  Source directory: $(CURDIR)"
	echo "  SRPM output directory: $(OUTDIR)"
	echo "  Spec file: $(spec)"
	
	rpmbuild -bs \
		--define "_sourcedir $(CURDIR)" \
		--define "_srcrpmdir $(OUTDIR)" \
		--define "_builddir $(CURDIR)" \
		$(spec) || (echo "ERROR: rpmbuild failed"; exit 1)
	
	@echo ""
	@echo "Verifying SRPM was created..."
	@ls -lh $(OUTDIR)/*.src.rpm 2>/dev/null || echo "Checking for SRPM..."
	@if [ -f $(OUTDIR)/*.src.rpm ]; then \
		echo "SRPM created successfully!"; \
		ls -lh $(OUTDIR)/*.src.rpm; \
	else \
		echo "ERROR: No SRPM found in $(OUTDIR)"; \
		ls -lhR $(OUTDIR)/ || true; \
		exit 1; \
	fi
	
	@echo ""
	@echo "Checking if COPR results directory exists..."
	@if [ "$(OUTDIR)" != "/var/lib/copr-rpmbuild/results" ] && [ -d "/var/lib/copr-rpmbuild/results" ]; then \
		echo "Copying SRPM to /var/lib/copr-rpmbuild/results/"; \
		cp -v $(OUTDIR)/*.src.rpm /var/lib/copr-rpmbuild/results/ || echo "Could not copy to /var/lib/copr-rpmbuild/results"; \
	fi
	
	@echo ""
	@echo "========================================="
	@echo "SRPM build completed successfully!"
	@echo "========================================="
	@echo "Output location: $(OUTDIR)"
	@ls -lh $(OUTDIR)/*.src.rpm

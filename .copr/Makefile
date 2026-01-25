# COPR Makefile - automatically used by COPR build system
# This file should be in .copr/Makefile

# Extract version from spec file
VERSION := $(shell grep "^%define version" rhtlc.spec | awk '{print $$3}')
OUTDIR ?= .

.PHONY: srpm
srpm:
	@echo "========================================="
	@echo "COPR Build: Preparing RHTLC SRPM"
	@echo "Version: $(VERSION)"
	@echo "Output: $(OUTDIR)"
	@echo "========================================="
	@echo ""
	
	# Download binaries from GitHub releases
	@echo "Downloading rhtlc CLI binary..."
	curl -f -L -o rhtlc-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-x86_64
	
	@echo "Downloading rhtlc GUI binary..."
	curl -f -L -o rhtlc-gui-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-x86_64
	
	# Verify binaries were downloaded
	@test -f rhtlc-linux-x86_64 || (echo "ERROR: CLI binary not found"; exit 1)
	@test -f rhtlc-gui-linux-x86_64 || (echo "ERROR: GUI binary not found"; exit 1)
	
	@echo ""
	@echo "Binary sizes:"
	@ls -lh rhtlc-linux-x86_64 rhtlc-gui-linux-x86_64
	@echo ""
	
	# Build SRPM
	@echo "Building source RPM..."
	rpmbuild -bs \
		--define "_sourcedir $(CURDIR)" \
		--define "_srcrpmdir $(OUTDIR)" \
		--define "_builddir $(CURDIR)" \
		rhtlc.spec
	
	@echo ""
	@echo "========================================="
	@echo "SRPM build completed successfully!"
	@echo "========================================="
	@ls -lh $(OUTDIR)/*.src.rpm

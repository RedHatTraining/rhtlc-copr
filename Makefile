# Makefile for local SRPM builds (mirrors .copr/Makefile)
# Downloads both x86_64 and arm64 binaries — COPR builds SRPM once for all chroots

# Extract version from spec file if not provided
VERSION ?= $(shell grep "^%define version" rhtlc.spec | awk '{print $$3}')
OUTDIR ?= $(CURDIR)

.PHONY: srpm
srpm:
	@echo "========================================="
	@echo "Building RHTLC SRPM"
	@echo "Version: $(VERSION)"
	@echo "Output directory: $(OUTDIR)"
	@echo "========================================="
	@echo ""
	
	# Download binaries from releases directory (both arches)
	@echo "Downloading CLI binary (x86_64)..."
	curl -f -L -o rhtlc-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-x86_64
	
	@echo "Downloading GUI binary (x86_64)..."
	curl -f -L -o rhtlc-gui-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-x86_64

	@echo "Downloading CLI binary (arm64)..."
	curl -f -L -o rhtlc-linux-arm64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-arm64
	
	@echo "Downloading GUI binary (arm64)..."
	curl -f -L -o rhtlc-gui-linux-arm64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-arm64
	
	# Verify downloads
	@test -f rhtlc-linux-x86_64 || (echo "ERROR: CLI x86_64 binary not found"; exit 1)
	@test -f rhtlc-gui-linux-x86_64 || (echo "ERROR: GUI x86_64 binary not found"; exit 1)
	@test -f rhtlc-linux-arm64 || (echo "ERROR: CLI arm64 binary not found"; exit 1)
	@test -f rhtlc-gui-linux-arm64 || (echo "ERROR: GUI arm64 binary not found"; exit 1)
	
	@echo ""
	@echo "Downloaded files:"
	@ls -lh rhtlc-linux-x86_64 rhtlc-gui-linux-x86_64 rhtlc-linux-arm64 rhtlc-gui-linux-arm64
	@echo ""
	
	# Build SRPM
	@echo "Building SRPM with rpmbuild..."
	rpmbuild -bs \
		--define "_sourcedir $(CURDIR)" \
		--define "_srcrpmdir $(OUTDIR)" \
		rhtlc.spec
	
	@echo ""
	@echo "========================================="
	@echo "SRPM build completed!"
	@echo "========================================="
	@ls -lh $(OUTDIR)/*.src.rpm

.PHONY: sources
sources:
	@echo "Downloading sources..."
	@echo "Version: $(VERSION)"
	curl -f -L -o rhtlc-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-x86_64
	curl -f -L -o rhtlc-gui-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-x86_64
	curl -f -L -o rhtlc-linux-arm64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-arm64
	curl -f -L -o rhtlc-gui-linux-arm64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-arm64
	@echo "Sources downloaded"

.PHONY: clean
clean:
	rm -f rhtlc-linux-x86_64
	rm -f rhtlc-gui-linux-x86_64
	rm -f rhtlc-linux-arm64
	rm -f rhtlc-gui-linux-arm64
	rm -f *.src.rpm

.PHONY: help
help:
	@echo "RHTLC RPM Build Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  srpm     - Build source RPM (default for COPR)"
	@echo "  sources  - Download binaries from releases directory"
	@echo "  clean    - Remove downloaded files and built SRPMs"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  VERSION  - Version to build (auto-detected from spec file)"
	@echo "  OUTDIR   - Output directory (default: current directory)"
	@echo ""
	@echo "Examples:"
	@echo "  make srpm"
	@echo "  make srpm VERSION=5.1.0"
	@echo "  make srpm OUTDIR=/tmp"

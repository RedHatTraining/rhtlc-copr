# Makefile for local SRPM builds (mirrors .copr/Makefile)
# Downloads both x86_64 and arm64 onedir archives — COPR builds SRPM once for all chroots

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
	
	@echo "Downloading CLI onedir (x86_64)..."
	curl -f -L -o rhtlc-linux-x86_64.tar.gz \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-x86_64.tar.gz
	
	@echo "Downloading GUI onedir (x86_64)..."
	curl -f -L -o rhtlc-gui-linux-x86_64.tar.gz \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-x86_64.tar.gz

	@echo "Downloading CLI onedir (arm64)..."
	curl -f -L -o rhtlc-linux-arm64.tar.gz \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-arm64.tar.gz
	
	@echo "Downloading GUI onedir (arm64)..."
	curl -f -L -o rhtlc-gui-linux-arm64.tar.gz \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-arm64.tar.gz
	
	@test -f rhtlc-linux-x86_64.tar.gz || (echo "ERROR: CLI x86_64 archive not found"; exit 1)
	@test -f rhtlc-gui-linux-x86_64.tar.gz || (echo "ERROR: GUI x86_64 archive not found"; exit 1)
	@test -f rhtlc-linux-arm64.tar.gz || (echo "ERROR: CLI arm64 archive not found"; exit 1)
	@test -f rhtlc-gui-linux-arm64.tar.gz || (echo "ERROR: GUI arm64 archive not found"; exit 1)
	
	@echo ""
	@echo "Downloaded files:"
	@ls -lh rhtlc-linux-x86_64.tar.gz rhtlc-gui-linux-x86_64.tar.gz rhtlc-linux-arm64.tar.gz rhtlc-gui-linux-arm64.tar.gz
	@echo ""
	
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
	curl -f -L -o rhtlc-linux-x86_64.tar.gz \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-x86_64.tar.gz
	curl -f -L -o rhtlc-gui-linux-x86_64.tar.gz \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-x86_64.tar.gz
	curl -f -L -o rhtlc-linux-arm64.tar.gz \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-arm64.tar.gz
	curl -f -L -o rhtlc-gui-linux-arm64.tar.gz \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-arm64.tar.gz
	@echo "Sources downloaded"

.PHONY: clean
clean:
	rm -f rhtlc-linux-x86_64.tar.gz
	rm -f rhtlc-gui-linux-x86_64.tar.gz
	rm -f rhtlc-linux-arm64.tar.gz
	rm -f rhtlc-gui-linux-arm64.tar.gz
	rm -f rhtlc-linux-x86_64 rhtlc-gui-linux-x86_64 rhtlc-linux-arm64 rhtlc-gui-linux-arm64
	rm -f *.src.rpm

.PHONY: help
help:
	@echo "RHTLC RPM Build Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  srpm     - Build source RPM (default for COPR)"
	@echo "  sources  - Download onedir archives from releases directory"
	@echo "  clean    - Remove downloaded files and built SRPMs"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  VERSION  - Version to build (auto-detected from spec file)"
	@echo "  OUTDIR   - Output directory (default: current directory)"
	@echo ""
	@echo "Examples:"
	@echo "  make srpm"
	@echo "  make srpm VERSION=6.0.1"
	@echo "  make srpm OUTDIR=/tmp"

# Makefile for COPR builds
# This downloads the binaries from the releases directory to the SOURCES directory

VERSION ?= 3.4.3
SOURCES_DIR ?= $(CURDIR)

.PHONY: sources
sources:
	@echo "Preparing sources for RPM build..."
	@echo "Version: $(VERSION)"
	
	# Download binaries from releases directory
	curl -L -o $(SOURCES_DIR)/rhtlc-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-linux-x86_64
	
	curl -L -o $(SOURCES_DIR)/rhtlc-gui-linux-x86_64 \
		https://github.com/RedHatTraining/rhtlc-copr/raw/main/releases/$(VERSION)/rhtlc-gui-linux-x86_64
	
	# Copy desktop file
	cp -f RHTLC-GUI.desktop $(SOURCES_DIR)/
	
	@echo "Sources prepared successfully"

.PHONY: srpm
srpm: sources
	@echo "Building SRPM..."
	rpmbuild -bs --define "_sourcedir $(SOURCES_DIR)" \
		--define "_srcrpmdir $(CURDIR)" \
		rhtlc.spec
	@echo "SRPM created successfully"

.PHONY: clean
clean:
	rm -f $(SOURCES_DIR)/rhtlc-linux-x86_64
	rm -f $(SOURCES_DIR)/rhtlc-gui-linux-x86_64
	rm -f *.src.rpm

.PHONY: help
help:
	@echo "RHTLC RPM Build Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  sources  - Download binaries from releases directory"
	@echo "  srpm     - Build source RPM"
	@echo "  clean    - Remove downloaded files and built SRPMs"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  VERSION=3.4.3  - Version to build (default: 3.4.3)"
	@echo ""
	@echo "Examples:"
	@echo "  make sources VERSION=3.4.3"
	@echo "  make srpm VERSION=3.4.3"

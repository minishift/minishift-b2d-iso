BUILD_DIR=$(shell pwd)/build
CODE_DIR=$(shell pwd)/iso
VERSION=1.0.0

default: b2d_iso

.PHONY: init
init:
	mkdir -p $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: b2d_iso
b2d_iso: ISO_NAME=minishift-b2d
b2d_iso: iso_creation

.PHONY: iso_creation
iso_creation: init
	cd $(CODE_DIR); bash build.sh

.PHONY: get_gh-release
get_gh-release: init
	curl -sL https://github.com/progrium/gh-release/releases/download/v2.2.1/gh-release_2.2.1_linux_x86_64.tgz > $(BUILD_DIR)/gh-release_2.2.1_linux_x86_64.tgz
	tar -xvf $(BUILD_DIR)/gh-release_2.2.1_linux_x86_64.tgz -C $(BUILD_DIR)
	rm -fr $(BUILD_DIR)/gh-release_2.2.1_linux_x86_64.tgz

.PHONY: release
release: b2d_iso get_gh-release
	rm -rf release && mkdir -p release
	cp $(BUILD_DIR)/minishift-b2d.iso release/
	$(BUILD_DIR)/gh-release checksums sha256
	$(BUILD_DIR)/gh-release create minishift/minishift-b2d-iso $(VERSION) master v$(VERSION)

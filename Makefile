BUILD_DIR=$(shell pwd)/build
CODE_DIR=$(shell pwd)/iso
VERSION=1.0.0
GITTAG=$(shell git rev-parse --short HEAD)
DATE=$(shell date +"%d%m%Y%H%M%S")
ISO_NAME=minishift-b2d
OSRELEASE_FILE=os-release
OSRELEASE_TEMPLATE=os-release.template

default: iso

.PHONY: init
init:
	mkdir -p $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	rm -f $(CODE_DIR)/$(OSRELEASE_FILE)

.PHONY: iso
iso: init
	#Creating minishift-b2d ISO specific /etc/os-release file.
	isoname='$(ISO_NAME)' version='$(VERSION)' build_id='$(GITTAG)-$(DATE)' envsubst < $(CODE_DIR)/$(OSRELEASE_TEMPLATE) > $(CODE_DIR)/$(OSRELEASE_FILE)
	cd $(CODE_DIR); bash build.sh

.PHONY: get_gh-release
get_gh-release: init
	curl -sL https://github.com/progrium/gh-release/releases/download/v2.2.1/gh-release_2.2.1_linux_x86_64.tgz > $(BUILD_DIR)/gh-release_2.2.1_linux_x86_64.tgz
	tar -xvf $(BUILD_DIR)/gh-release_2.2.1_linux_x86_64.tgz -C $(BUILD_DIR)
	rm -fr $(BUILD_DIR)/gh-release_2.2.1_linux_x86_64.tgz

.PHONY: release
release: iso get_gh-release
	rm -rf release && mkdir -p release
	cp $(BUILD_DIR)/minishift-b2d.iso release/
	$(BUILD_DIR)/gh-release checksums sha256
	$(BUILD_DIR)/gh-release create minishift/minishift-b2d-iso $(VERSION) master v$(VERSION)

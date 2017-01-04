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

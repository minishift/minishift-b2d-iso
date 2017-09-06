BUILD_DIR=$(shell pwd)/build
BIN_DIR=$(BUILD_DIR)/bin
CODE_DIR=$(shell pwd)/iso
VERSION=1.1.0
GITTAG=$(shell git rev-parse --short HEAD)
DATE=$(shell date +"%d%m%Y%H%M%S")
ISO_NAME=minishift-b2d
OSRELEASE_FILE=os-release
OSRELEASE_TEMPLATE=os-release.template
MINISHIFT_LATEST_URL=$(shell python tests/utils/minishift_latest_version.py)
ARCHIVE_FILE=$(shell echo $(MINISHIFT_LATEST_URL) | rev | cut -d/ -f1 | rev)

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
	# Creating minishift-b2d ISO specific /etc/os-release file.
	isoname='$(ISO_NAME)' version='$(VERSION)' build_id='$(GITTAG)-$(DATE)' envsubst < $(CODE_DIR)/$(OSRELEASE_TEMPLATE) > $(CODE_DIR)/$(OSRELEASE_FILE)
	cd $(CODE_DIR); bash build.sh

$(GOPATH)/bin/gh-release:
	go get -u github.com/progrium/gh-release/...

.PHONY: release
release: iso $(GOPATH)/bin/gh-release
	rm -rf release && mkdir -p release
	cp $(BUILD_DIR)/minishift-b2d.iso release/
	gh-release checksums sha256
	gh-release create minishift/minishift-b2d-iso $(VERSION) master v$(VERSION)

$(BIN_DIR)/minishift:
	@echo "Downloading latest minishift binary..."
	@mkdir -p $(BIN_DIR)
	@cd $(BIN_DIR) && \
	curl -LO --progress-bar $(MINISHIFT_LATEST_URL) && \
	tar xzf $(ARCHIVE_FILE)
	@echo "Done."

.PHONY: test
test: $(BIN_DIR)/minishift
	# avocado run $(SHOW_LOG) tests/test.py
	sh tests/test.sh

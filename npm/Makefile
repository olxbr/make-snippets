# DEPENDS ON
$(if $(value ARTIFACT_NAME),,$(error "ARTIFACT_NAME is required for npm/Makefile")) 
$(if $(value PROJECT_DIR),,$(error "PROJECT_DIR is required for npm/Makefile")) 

# OPTIONAL
# $BUILD_DIR

# build directory
BUILD_DIR?=$(PROJECT_DIR)/dist

NODE_VERSION:=7-alpine

NODE_IMAGE:=node:$(NODE_VERSION) 

# checks npm binary already exists target 
npm:
	@if ! docker images $(NODE_IMAGE) | awk '{ print $$2 }' | grep -q -F $(NODE_VERSION); then echo "pulling $(NODE_IMAGE)"; docker pull $(NODE_IMAGE) ; fi

NPM_BINARY:=docker run $(NODE_IMAGE) npm

# path to artifact
NPM_ARTIFACT:=$(BUILD_DIR)/$(ARTIFACT_NAME)

build: npm $(BUILD_DIR)
	$(NPM_BINARY) upgrade && npm install && tar -cf $(NPM_ARTIFACT) node_modules app.js lib

$(NPM_ARTIFACT): build

artifact: $(NPM_ARTIFACT)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

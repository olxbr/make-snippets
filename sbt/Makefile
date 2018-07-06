# DEPENDS ON
$(if $(value ARTIFACT_NAME),,$(error "ARTIFACT_NAME is required for sbt/Makefile")) 
$(if $(value ORG),,$(error "ORG is required for sbt/Makefile")) 
$(if $(value PROJECT_DIR),,$(error "PROJECT_DIR is required for sbt/Makefile")) 

# OPTIONAL
# $BUILD_DIR

# EXPORTS gradle related targets and variables
#
# build directory
BUILD_DIR?=$(PROJECT_DIR)/target/universal

# sbt's binary
SBT_BINARY:=docker run -it -v $(PROJECT_DIR):/app -v "$$HOME/.ivy2":/root/.ivy2  williamyeh/sbt:0.13.8

# java artifact
ARTIFACT:=$(BUILD_DIR)/$(ARTIFACT_NAME)

# absolute path java artifact target
$(ARTIFACT):
	$(SBT_BINARY) -Dversion=$(VERSION) -Dname=$(PROJECT_NAME) universal:packageZipTarball

# build target
build: $(ARTIFACT)

# artifact target
artifact: build

clean:
	rm -rf $(BUILD_DIR)/*

# DEPENDS ON
$(if $(value ARTIFACT_NAME),,$(error "ARTIFACT_NAME is required for gra/Makefile")) 
$(if $(value ORG),,$(error "ORG is required for gra/Makefile")) 
$(if $(value PROJECT_DIR),,$(error "PROJECT_DIR is required for gra/Makefile")) 

# OPTIONAL
# $BUILD_DIR
# $GRADLE_EXTRA_ARGS

# EXPORTS gradle related targets and variables
#
# build directory
BUILD_DIR?=$(PROJECT_DIR)/build/libs

# gradle's binary
GRADLE_BINARY:=$(if $(wildcard ./gradlew),./gradlew,gradle)

# java artifact
JAVA_ARTIFACT:=$(BUILD_DIR)/$(ARTIFACT_NAME)

# absolute path java artifact target
$(JAVA_ARTIFACT): 
	$(GRADLE_BINARY) -PartifactName=$(ARTIFACT_NAME) clean build $(GRADLE_EXTRA_ARGS)

# a test target
test: build
	$(GRADLE_BINARY) test $(GRADLE_EXTRA_ARGS)

list-dependencies:
	$(GRADLE_BINARY) -q dependencies $(GRADLE_EXTRA_ARGS)

analise-code: build project-version
	$(GRADLE_BINARY) -Pversion=$(VERSION) sonarqube $(GRADLE_EXTRA_ARGS)

# build target
build: $(JAVA_ARTIFACT)

# compiling test resources
compile-test:
	$(GRADLE_BINARY) compileTestJava

# artifact target
artifact: build

project-version:
	$(if $(value VERSION),,$(error "VERSION is required for gra/Makefile"))

# run docker-compose
gradle-compose-up:
	$(GRADLE_BINARY) composeUp $(GRADLE_EXTRA_ARGS)
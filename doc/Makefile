# DEPENDS ON
$(if $(value ARTIFACT),,$(error "ARTIFACT is required for doc/Makefile"))
$(if $(value CONTAINER_ID),,$(error "CONTAINER_ID is required for doc/Makefile"))
$(if $(value ORG),,$(error "ORG is required for doc/Makefile"))
$(if $(value PROJECT_NAME),,$(error "PROJECT_NAME is required for doc/Makefile"))
$(if $(value VERSION),,$(error "VERSION is required for doc/Makefile"))
$(if $(value PROJECT_DIR),,$(error "PROJECT_DIR is required for doc/Makefile"))

# OPTIONAL VALUES FOR
# $FORCE
# $NO_DAEMON
#
# EXPORTS docker related variables and targets

# a container specific suffix
SUFFIX?=

# the image's name
ifeq ($(IMAGE_NAME),)
  override IMAGE_NAME:=$(ORG)/$(PROJECT_NAME):$(VERSION)
endif

# the container's name
CONTAINER_NAME:=$(PROJECT_NAME)-$(CONTAINER_ID)$(SUFFIX)

# dockerfile path
DOCKER_FILE_PATH?=$(PROJECT_DIR)/Dockerfile

# docker's work dir
WORKDIR:=/$(ORG)/$(PROJECT_NAME)

# sensible inside container log location
CONTAINER_LOG?=/var/log

# remove container or daemon flag
ifdef FORCE
  REMOVE_CONTAINER_FLAG:=--rm
else
  ifndef NO_DAEMON
    DAEMON_FLAG:=-d --restart="always"
  endif
endif

# discovery the local address ip to run docker-compose
export DOCKERHOST=$(shell ifconfig |\
	grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' |\
	grep -v 127.0.0.1 |\
	awk '{ print $$2 }' |\
	cut -f2 -d: |\
	head -n1)

DOCKER_LOGIN:=docker login -p "$(DOCKER_PASSWORD)" -u "$(DOCKER_USER)"

# makes the image
image: artifact
	@if ! docker images $(IMAGE_NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo 'building image'; docker build --rm=false --build-arg ARTIFACT=$(ARTIFACT) -f $(DOCKER_FILE_PATH) -t $(IMAGE_NAME) . ; fi

# pushes the image to dockerhub
push: image
	docker push $(IMAGE_NAME)
ifdef DOCKER_REGISTRY_DOMAIN
	docker tag $(IMAGE_NAME) $(DOCKER_REGISTRY_DOMAIN)/$(IMAGE_NAME)
	docker push $(DOCKER_REGISTRY_DOMAIN)/$(IMAGE_NAME)
endif

pull:
	docker pull $(IMAGE_NAME)

# removes the container
rm:
	docker rm -f $(CONTAINER_NAME)

remove-image:
	docker rmi -f $(IMAGE_NAME)

validate-image: pull remove-image

# kills the container
kill:
	docker kill $(CONTAINER_NAME)

# attaches to the container
attach:
	docker exec -ti $(CONTAINER_NAME) /bin/bash

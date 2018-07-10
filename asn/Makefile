# DEPENDS ON
# a target called `stack-variables-setup` and
$(if $(value ENV),,$(error "ENV is required for asn/Makefile"))
$(if $(value ORG),,$(error "ORG is required for asn/Makefile"))
$(if $(value PROJECT_DIR),,$(error "PROJECT_DIR is required for asn/Makefile"))

ASNO_DIR:=$(PROJECT_DIR)/el-asno-alado

HOST_OUTPUT_DIR:=$(PROJECT_DIR)/deploy/output
HOST_TEMPLATE_DIR:=$(ASNO_DIR)/templates
HOST_VARIABLES_DIR:=$(PROJECT_DIR)/deploy/variables
HOST_CFNDSL_DIR:=$(ASNO_DIR)/cfndsl

ASNO_OUTPUT_DIR:=/project/deploy/output
ASNO_TEMPLATE_DIR:=/project/deploy/templates
ASNO_VARIABLES_DIR:=/project/deploy/variables
ASNO_CFNDSL_DIR:=/vivareal/cfndsl

NESTED_ASNO_VERSION:=$(shell cd $(ASNO_DIR) \
		&& COMMIT_HASH=`git rev-parse --short HEAD` \
		&& echo `git show --format=%cd --date=format:'%y%m%d.%H%M' $$COMMIT_HASH | head -n 1`-$$COMMIT_HASH)

ASNO_IMAGE_NAME:=$(ORG)/asno:$(NESTED_ASNO_VERSION)
ASNO_DOCKER_RUN=docker run \
						--rm \
						--net=host \
						-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) \
						-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
						-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
						-v $(HOST_OUTPUT_DIR):$(ASNO_OUTPUT_DIR) \
						-v $(HOST_TEMPLATE_DIR):$(ASNO_TEMPLATE_DIR) \
						-v $(HOST_VARIABLES_DIR):$(ASNO_VARIABLES_DIR)

MERGE_YAML_RUN=docker run \
						--rm \
						--net=host \
						-v $(HOST_VARIABLES_DIR):$(ASNO_VARIABLES_DIR) \
						-v $(HOST_OUTPUT_DIR):$(ASNO_OUTPUT_DIR) \
						-i node:7

ASNO_SHELL=$(ASNO_DOCKER_RUN) -i $(ASNO_IMAGE_NAME)

asno-debug-shell:
	$(ASNO_DOCKER_RUN) \
		-v $(HOST_CFNDSL_DIR):$(ASNO_CFNDSL_DIR) \
		--entrypoint=/bin/sh \
		-ti $(ASNO_IMAGE_NAME)

asno-binary:
	cd $(ASNO_DIR) && make VERSION=$(NESTED_ASNO_VERSION) PROJECT_DIR=$(ASNO_DIR) check-image

NAME_TAG:=$(STACK_NAME)
STACK_DESCRIPTION:=$(TEMPLATE)-$(VARIABLES)-$(ENV)
stack-description: build-version build-variables stack-variables stack-template name-tag asno-binary
	$(ASNO_SHELL) cfndsl --verbose \
		--define "adhoc_params={ StackName: '$(STACK_NAME)'}" \
		-y $(ASNO_OUTPUT_DIR)/variables.yml \
		-o $(ASNO_OUTPUT_DIR)/$(STACK_DESCRIPTION).json \
		$(ASNO_TEMPLATE_DIR)/$(TEMPLATE).rb

build-variables:
	$(MERGE_YAML_RUN) /bin/bash -c "\
		npm i -g merge-yaml-cli; \
		merge-yaml \
			-i \
			$(ASNO_VARIABLES_DIR)/$(VARIABLES).yml \
			$(if $(value REGION_VARIABLES),$(ASNO_VARIABLES_DIR)/$(REGION_VARIABLES).yml,) \
			$(if $(value SPOT_VARIABLES),$(ASNO_VARIABLES_DIR)/$(SPOT_VARIABLES).yml,) \
			-o $(ASNO_OUTPUT_DIR)/variables.yml; \
			"

validate-stack: stack-description
	$(ASNO_SHELL) aws cloudformation validate-template \
		--template-body file://$(ASNO_OUTPUT_DIR)/$(STACK_DESCRIPTION).json

set-stack-cmd:
	$(eval STACK_CMD=$(shell $(ASNO_SHELL) aws cloudformation describe-stack-events --stack-name $(STACK_NAME) > /dev/null; if [[ $$? -eq 0 ]] ; then echo update ; else echo create ; fi))

deploy-stack: set-stack-cmd validate-stack stack-name validate-image
	$(ASNO_SHELL) aws cloudformation $(STACK_CMD)-stack \
	--tags Key=Name,Value=$(NAME_TAG) \
		Key=Product,Value=$(PRODUCT) \
		Key=Env,Value=$(ENV) \
		Key=App,Value=$(PROJECT_NAME) \
		Key=Process,Value=$(PROCESS) \
		Key=Release,Value=$(VERSION) \
	--stack-name $(STACK_NAME) --template-body file://$(ASNO_OUTPUT_DIR)/$(STACK_DESCRIPTION).json \
	&& $(ASNO_SHELL) aws cloudformation wait stack-$(STACK_CMD)-complete --stack-name $(STACK_NAME)

destroy-stack: asno-binary stack-name
	$(ASNO_SHELL) aws cloudformation delete-stack --stack-name $(STACK_NAME) \
	&& $(ASNO_SHELL) aws cloudformation wait stack-delete-complete --stack-name $(STACK_NAME)

DESCRIBE_STACK=$(ASNO_SHELL) aws cloudformation describe-stack-events --stack-name $(STACK_NAME)

set-cfn-stack-id:
	$(eval CFN_STACK_ID=$(shell $(DESCRIBE_STACK) | grep -m1 "StackId" | tr -d '\n' | cut -d "\"" -f 4 | xargs echo))
	echo $(CFN_STACK_ID)

build-version:
	$(if $(value VERSION),,$(error "VERSION is required for asn/Makefile"))

name-tag:
	$(if $(value NAME_TAG),,$(error "NAME_TAG is required for asn/Makefile"))

stack-name:
	$(if $(value STACK_NAME),,$(error "STACK_NAME is required for asn/Makefile"))

stack-template:
	$(if $(value TEMPLATE),,$(error "TEMPLATE is required for asn/Makefile"))

stack-variables: stack-variables-setup
	$(if $(value VARIABLES),,$(error "VARIABLES is required for asn/Makefile"))

$(HOST_OUTPUT_DIR):
	mkdir -p $(HOST_OUTPUT_DIR)

$(HOST_VARIABLES_DIR):
	mkdir -p $(HOST_VARIABLES_DIR)

$(HOST_TEMPLATE_DIR):
	mkdir -p $(HOST_TEMPLATE_DIR)

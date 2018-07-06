# DEPENDS ON
# a target called `user-data-setup`
$(if $(value DOCKER_LOGIN),,$(error "DOCKER_LOGIN is required for usr/Makefile"))
$(if $(value RUN_CMD),,$(error "RUN_CMD is required for usr/Makefile"))
$(if $(value PROJECT_DIR),,$(error "PROJECT_DIR is required for usr/Makefile"))

USER_DATA_DIR:=$(PROJECT_DIR)/deploy/variables
USER_DATA:=$(USER_DATA_DIR)/user-data.sh

user-data: RUN_OPTS+=-Djava.rmi.server.hostname=$$(/usr/bin/curl -s --connect-timeout 2 curl http://169.254.169.254/latest/meta-data/local-ipv4)
user-data: LOG=/var/log
user-data: user-data-setup $(USER_DATA_DIR)
	echo "#!/bin/bash" > $(USER_DATA)
ifdef DOCKER_REGISTRY_DOMAIN
	echo "echo '{\"registry-mirrors\":[\"https://$(DOCKER_REGISTRY_DOMAIN)\"]}' > /etc/docker/daemon.json" >> $(USER_DATA)
	echo "service docker restart" >> $(USER_DATA)
endif
	echo $(DOCKER_LOGIN) >> $(USER_DATA)
	echo $(RUN_CMD) >> $(USER_DATA)
ifdef EXTRA_USER_DATA
	echo $(EXTRA_USER_DATA) >> $(USER_DATA)
endif

user-data-and-shutdown: stack-name user-data-setup $(USER_DATA_DIR)
	echo "#!/bin/bash" > $(USER_DATA)
	echo "export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)" >> $(USER_DATA)
	echo "export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)" >> $(USER_DATA)
	echo "export AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION)" >> $(USER_DATA)
ifdef DOCKER_REGISTRY_DOMAIN
	echo "echo '{\"registry-mirrors\":[\"https://$(DOCKER_REGISTRY_DOMAIN)\"]}' > /etc/docker/daemon.json" >> $(USER_DATA)
	echo "service docker restart" >> $(USER_DATA)
endif
	echo $(DOCKER_LOGIN) >> $(USER_DATA)
	echo $(RUN_CMD) "; aws cloudformation delete-stack --stack-name" $(STACK_NAME) >> $(USER_DATA)
ifdef EXTRA_USER_DATA
	echo $(EXTRA_USER_DATA) >> $(USER_DATA)
endif

user-data-and-zero-asg: user-data-setup $(USER_DATA_DIR)
	echo "#!/bin/bash" > $(USER_DATA)
	echo "export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)" >> $(USER_DATA)
	echo "export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)" >> $(USER_DATA)
	echo "export AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION)" >> $(USER_DATA)
ifdef DOCKER_REGISTRY_DOMAIN
	echo "echo '{\"registry-mirrors\":[\"https://$(DOCKER_REGISTRY_DOMAIN)\"]}' > /etc/docker/daemon.json" >> $(USER_DATA)
	echo "service docker restart" >> $(USER_DATA)
endif
	echo $(DOCKER_LOGIN) >> $(USER_DATA)
	cat make/extensions/scripts/set-asg-desired-to-zero.sh >> $(USER_DATA)
	echo $(RUN_CMD) "; set-asg-desired-to-zero" >> $(USER_DATA)
ifdef EXTRA_USER_DATA
	echo $(EXTRA_USER_DATA) >> $(USER_DATA)
endif

$(USER_DATA_DIR):
	mkdir -p $(USER_DATA_DIR)

stack-name:
	$(if $(value STACK_NAME),,$(error "STACK_NAME is required for usr/Makefile"))

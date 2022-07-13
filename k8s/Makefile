# DEPENDS ON
$(if $(value ENV),,$(error "ENV is required for k8s/Makefile"))
$(if $(value IMAGE_NAME),,$(error "IMAGE_NAME is required for k8s/Makefile"))
$(if $(value DEPLOY_NAME),,$(error "DEPLOY_NAME is required for k8s/Makefile"))
$(if $(value VERSION),,$(error "VERSION is required for k8s/Makefile"))

EXTRA_K8S_ARGS?=

DEFAULT_K8S_REPLICAS:=1
REPLICAS:=$(DEFAULT_K8S_REPLICAS)

ENVSUBST_RUN?= ENV=$(ENV) \
	IMAGE_NAME=$(IMAGE_NAME) \
	RUN_OPTS='$(RUN_OPTS)' \
	DEPLOY_NAME=$(DEPLOY_NAME) \
	VERSION=$(VERSION) \
	REPLICAS=$(REPLICAS) \
	$(EXTRA_K8S_ARGS) \
	envsubst

K8S_TMPL_DIR:=$(PROJECT_DIR)/deploy/k8s
K8S_DIST_DIR:=$(K8S_TMPL_DIR)/dist

K8S_TOKEN?=$(shell if [[ "$(ENV)" == "prod" ]] ; then echo $(K8S_SEARCH_TOKEN_PROD) ; else echo $(K8S_SEARCH_TOKEN_QA) ; fi)

K8S_NAMESPACE?=search
KUBECTL_CMD:=kubectl -n $(K8S_NAMESPACE) -s $(K8S_CLUSTER) --token=$(K8S_TOKEN) --insecure-skip-tls-verify

K8S_OVERRIDES?=$(shell if [[ -f $(K8S_DIST_DIR)/overrides.json ]] ; then echo "--overrides='"; cat $(K8S_DIST_DIR)/overrides.json; echo "'" ; else echo "" ; fi)

dist-path:
	mkdir -p $(K8S_DIST_DIR)

process-templates: replicas dist-path
	$(ENVSUBST_RUN) < $(K8S_TMPL_DIR)/deployment.yaml.tmpl > $(K8S_DIST_DIR)/deployment.yaml

process-templates-inline: replicas dist-path
	$(ENVSUBST_RUN) < $(K8S_TMPL_DIR)/overrides.json.tmpl > $(K8S_DIST_DIR)/overrides.json

process-full-templates: process-templates
	$(ENVSUBST_RUN) < $(K8S_TMPL_DIR)/service.yaml.tmpl > $(K8S_DIST_DIR)/service.yaml ; \
	$(ENVSUBST_RUN) < $(K8S_TMPL_DIR)/ingress.yaml.tmpl > $(K8S_DIST_DIR)/ingress.yaml

deploy-k8s: check-k8s-cluster-var process-templates
	$(KUBECTL_CMD) apply -f $(K8S_DIST_DIR)/deployment.yaml

deploy-full-k8s: check-k8s-cluster-var process-full-templates deploy-k8s
	$(KUBECTL_CMD) apply -f $(K8S_DIST_DIR)/service.yaml ; \
	$(KUBECTL_CMD) apply -f $(K8S_DIST_DIR)/ingress.yaml

destroy-k8s: check-k8s-cluster-var
	$(KUBECTL_CMD) delete deploy ${DEPLOY_NAME}

destroy-full-k8s: check-k8s-cluster-var destroy-k8s
	$(KUBECTL_CMD) delete service ${DEPLOY_NAME}-service ; \
	$(KUBECTL_CMD) delete ingress ${DEPLOY_NAME}-ingress

run-k8s: check-k8s-cluster-var
	$(KUBECTL_CMD) run $(DEPLOY_NAME) --image=$(IMAGE_NAME) -i --rm --restart=Never $(K8S_RUN_ARGS) $(K8S_OVERRIDES)

logs-k8s: check-k8s-cluster-var
	$(KUBECTL_CMD) logs $(DEPLOY_NAME) -f

check-k8s-cluster-var:
	$(if $(value K8S_CLUSTER),,$(error "K8S_CLUSTER is required for k8s/Makefile"))

replicas:
	$(eval REPLICAS=$(shell ${KUBECTL_CMD} describe deployment ${DEPLOY_NAME} | grep Replicas: | awk '{print $$2}'))
	$(eval REPLICAS=$(shell if [[ ${REPLICAS} -gt 1 ]]; then echo ${REPLICAS}; else echo ${DEFAULT_K8S_REPLICAS}; fi;))
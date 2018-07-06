# DEPENDS ON
$(if $(value ENV),,$(error "ENV is required for k8s/Makefile"))
$(if $(value IMAGE_NAME),,$(error "IMAGE_NAME is required for k8s/Makefile"))
$(if $(value DEPLOY_NAME),,$(error "DEPLOY_NAME is required for k8s/Makefile"))
$(if $(value VERSION),,$(error "VERSION is required for k8s/Makefile"))
$(if $(value CLUSTER_NAME),,$(error "CLUSTER_NAME is required for k8s/Makefile"))

EXTRA_K8S_ARGS?=

ENVSUBST_RUN:= ENV=$(ENV) \
	IMAGE_NAME=$(IMAGE_NAME) \
	RUN_OPTS='$(RUN_OPTS)' \
	DEPLOY_NAME=$(DEPLOY_NAME) \
	VERSION=$(VERSION) \
	$(EXTRA_K8S_ARGS) \
	envsubst

K8S_TMPL_DIR:=$(PROJECT_DIR)/deploy/k8s
K8S_DIST_DIR:=$(K8S_TMPL_DIR)/dist

K8S_TOKEN?=$(shell if [[ "$(ENV)" == "prod" ]] ; then echo $(K8S_SEARCH_TOKEN_PROD) ; else echo $(K8S_SEARCH_TOKEN_QA) ; fi)

KUBECTL_SEARCH:=kubectl -n search -s $(CLUSTER_NAME) --token=$(K8S_TOKEN) --insecure-skip-tls-verify

K8S_OVERRIDES?=$(shell if [[ -f $(K8S_DIST_DIR)/overrides.json ]] ; then echo "--overrides='"; cat $(K8S_DIST_DIR)/overrides.json; echo "'" ; else echo "" ; fi)

dist-path:
	mkdir -p $(K8S_DIST_DIR)

process-templates: dist-path
	$(ENVSUBST_RUN) < $(K8S_TMPL_DIR)/deployment.yaml.tmpl > $(K8S_DIST_DIR)/deployment.yaml

process-templates-inline: dist-path
	$(ENVSUBST_RUN) < $(K8S_TMPL_DIR)/overrides.json.tmpl > $(K8S_DIST_DIR)/overrides.json

process-full-templates: process-templates
	$(ENVSUBST_RUN) < $(K8S_TMPL_DIR)/service.yaml.tmpl > $(K8S_DIST_DIR)/service.yaml ; \
	$(ENVSUBST_RUN) < $(K8S_TMPL_DIR)/ingress.yaml.tmpl > $(K8S_DIST_DIR)/ingress.yaml ;

deploy-k8s: validate-image process-templates
	$(KUBECTL_SEARCH) apply --record -f $(K8S_DIST_DIR)/deployment.yaml

deploy-full-k8s: process-full-templates deploy-k8s
	$(KUBECTL_SEARCH) apply --record -f $(K8S_DIST_DIR)/service.yaml ; \
	$(KUBECTL_SEARCH) apply --record -f $(K8S_DIST_DIR)/ingress.yaml ; \

destroy-k8s:
	$(KUBECTL_SEARCH) delete deploy ${DEPLOY_NAME} ;

destroy-full-k8s: destroy-k8s
	$(KUBECTL_SEARCH) delete service ${DEPLOY_NAME}-service ; \
	$(KUBECTL_SEARCH) delete ingress ${DEPLOY_NAME}-ingress ;

run-k8s:
	$(KUBECTL_SEARCH) run $(DEPLOY_NAME) --image=$(IMAGE_NAME) -i --rm --restart=Never $(K8S_RUN_ARGS) $(K8S_OVERRIDES)

logs-k8s:
	$(KUBECTL_SEARCH) logs $(DEPLOY_NAME) -f

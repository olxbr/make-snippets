# DEPENDS ON
$(if $(value IMAGE_NAME),,$(error "IMAGE_NAME is required for slk/Makefile"))
$(if $(value DEPLOY_NAME),,$(error "DEPLOY_NAME is required for slk/Makefile"))

SLK_CHANNEL?=alerts-dev
SLK_USER_GROUP?=search
SLK_CD_URL?=http://gocd.vivareal.com

notify-success-build: SLK_ICON=ci
notify-success-build: set-slk-hook
	curl -X POST -H 'Content-type: application/json' \
		--data '{"text": "@$(SLK_USER_GROUP) image *$(IMAGE_NAME)* pushed to dockerhub :muscle:.\nDeploy image clicking <$(SLK_CD_URL)|here> ", "channel": "#$(SLK_CHANNEL)", "username": "@$(PROJECT_NAME)-build", "icon_emoji": ":$(SLK_ICON):"}' \
		$(SLK_HOOK)

notify-pipeline-deploy: SLK_ICON=alto-astral
notify-pipeline-deploy: set-slk-hook
	curl -X POST -H 'Content-type: application/json' \
		--data '{"text": "@$(SLK_USER_GROUP) image *$(IMAGE_NAME)* was deployed in QA :muscle:.\nTo deploy this image in prod, please use <$(SLK_CD_URL)|here> ", "channel": "#$(SLK_CHANNEL)", "username": "@$(PROJECT_NAME)-pipeline", "icon_emoji": ":$(SLK_ICON):"}' \
		$(SLK_HOOK)


notify-success-deploy: SLK_ICON?=cfn
notify-success-deploy: set-slk-hook slk-deploy-url
	curl -X POST -H 'Content-type: application/json' \
		--data '{"text": "@$(SLK_USER_GROUP) stack *$(DEPLOY_NAME)* with *$(ENV)* using image version *$(IMAGE_NAME)* was deployed successfully. More details <$(SLK_DEPLOY_URL)|here>", "channel": "#$(SLK_CHANNEL)", "username": "@$(PROJECT_NAME)-deploy", "icon_emoji": ":$(SLK_ICON):"}' \
		$(SLK_HOOK)


notify-success-teardown: SLK_ICON?=cfn
notify-success-teardown: set-slk-hook slk-token
	curl -X POST -H 'Content-type: application/json' \
		--data '{"text": "@$(SLK_USER_GROUP) stack *$(DEPLOY_NAME)* with *$(ENV)* was teardown successfully. More details <$(SLK_DEPLOY_URL)|here>", "channel": "#$(SLK_CHANNEL)", "username": "@$(PROJECT_NAME)-teardown", "icon_emoji": ":$(SLK_ICON):"}' \
		$(SLK_HOOK)

set-slk-hook: slk-token
	$(eval SLK_HOOK=https://hooks.slack.com/services/$(SLK_TOKEN))

slk-deploy-url:
	$(if $(value SLK_DEPLOY_URL),,$(error "SLK_DEPLOY_URL is required for slk/Makefile"))

slk-token:
	$(if $(value SLK_TOKEN),,$(error "SLK_TOKEN is required for slk/Makefile"))

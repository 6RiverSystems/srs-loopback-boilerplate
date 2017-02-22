# Docker Image Name (is taken from package.json file)
NAME = $(shell node -pe "require('./package.json').name")

# Image Version (is taken from package.json file)
VERSION = $(shell git describe --long --tags --dirty --always)

# GCE Project ID
GCLOUD_PROJECT ?= plasma-column-128721
GCLOUD_COMPUTE_ZONE ?= us-central1-a

# CLUSTER
CLUSTER ?= staging

# NAMESPACE
NAMESPACE ?= default

# Google Conttainer Registry name
GCR_NAME = gcr.io/$(GCLOUD_PROJECT)/$(NAME):$(VERSION)

.PHONY: all check_exists run run_bash gcloud_tag clean build gcloud_push check_gcloud_env gcloud_config gcloud_deploy

all: build

# Perform a check if Docker image exists
check_exists:
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi

# Run image
run: check_exists
	docker run --rm -it \
		--name $(NAME) \
		$(NAME):$(VERSION)

stop:
	docker stop $(NAME)

# Used for quality diagnostics
# Opens bash session
run_bash: check_exists
	docker run --rm -it --entrypoint=/bin/bash $(NAME):$(VERSION)

# Remove Docker image
clean:
	@if docker images $(GCR_NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then docker rmi $(GCR_NAME); fi
	@if docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then docker rmi $(NAME):$(VERSION); fi

# Build Docker image
build:
	@docker build -t $(NAME):$(VERSION) .

# Tag current version with gcloud name
gcloud_tag:
	docker tag $(NAME):$(VERSION) $(GCR_NAME)

# Publish image to GKE registry
gcloud_push: check_exists gcloud_tag
	gcloud docker -- push $(GCR_NAME)

check_gcloud_env:
	@if [ -z "$(CLIENT_SECRET)" ]; then echo "CLIENT_SECRET environment variable is not set"; false; fi
	@if [ -z "$(GCLOUD_PROJECT)" ]; then echo "GCLOUD_PROJECT environment variable is not set"; false; fi
	@if [ -z "$(GCLOUD_COMPUTE_ZONE)" ]; then echo "GCLOUD_COMPUTE_ZONE environment variable is not set"; false; fi

gcloud_config: check_gcloud_env
	@echo $(CLIENT_SECRET) | base64 --decode > ${HOME}/client-secret.json
	@sudo /opt/google-cloud-sdk/bin/gcloud --quiet components update
	@sudo /opt/google-cloud-sdk/bin/gcloud --quiet components install kubectl
	@sudo chmod 757 /home/ubuntu/.config/gcloud/logs -R
	@sudo chown -R ubuntu:ubuntu /home/ubuntu/.config/gcloud
	@gcloud auth activate-service-account --key-file ${HOME}/client-secret.json
	@gcloud config set project $(GCLOUD_PROJECT)
	@gcloud config set compute/zone $(GCLOUD_COMPUTE_ZONE)
	@gcloud container clusters get-credentials $(CLUSTER)

check_deployment:
	@if [ -z "$(DEPLOYMENT)" ]; then echo "DEPLOYMENT environment variable is not set"; false; fi

gcloud_update: check_deployment
	@kubectl set image deployment/$(DEPLOYMENT) $(DEPLOYMENT)=$(GCR_NAME) --namespace=$(NAMESPACE)
	@kubectl rollout status deployment/$(DEPLOYMENT) --namespace=$(NAMESPACE)

gcloud_deploy: build gcloud_config gcloud_push gcloud_update


-include env_make

VMAUTH_VER ?= 1.93.11
VMAUTH_MINOR_VER=$(shell echo "${VMAUTH_VER}" | grep -oE '^[0-9]+\.[0-9]+')

# Remove minor version from tag
TAG ?= $(VMAUTH_MINOR_VER)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

REPO = ghcr.io/ramsalt/vmauth
NAME = vmauth-$(VMAUTH_MINOR_VER)

ENV = -e VMAUTH_TOKEN=test-token

.PHONY: build test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg VMAUTH_VER=$(VMAUTH_VER) \
		./

test:
	cd ./tests && IMAGE=$(REPO):$(TAG) NAME=$(NAME) VMAUTH_VER=$(VMAUTH_VER) ./run.sh

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm -it --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push

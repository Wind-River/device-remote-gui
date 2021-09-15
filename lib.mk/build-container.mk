# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

DOCKERFILE ?= dockerfiles/builder/wrlinux-21.builder
BUILD_CONTAINER_IMAGE ?= saxofon/wrlinux_builder:$(shell echo $(DOCKERFILE) | cut -d\. -f 1 | rev | cut -d- -f1 | rev)
BUILD_CONTAINER ?= wrl-builder-$(shell id -u)

help:: build-container-help

build-container-help:
	$(ECHO) "\n--- build container ---"
	$(ECHO) " build-container-image          : build build-container image, $(BUILD_CONTAINER_IMAGE)"
	$(ECHO) " build-container-start          : start and sets up the build container environment"
	$(ECHO) " build-container-shell          : gives a bash shell running inside build container"
	$(ECHO) " build-container-root-shell     : gives a bash shell running inside build container as root"
	$(ECHO) " build-container-stop           : stops the build container"

build-container-image:
ifeq ($(BUILD_CONTAINER_IMAGE), saxofon/wrlinux_builder:21)
	$(Q)read -p "Are you really sure you want to update production build container image? [y/N]" -t 4 answer ; \
	if [ "$$answer" != "y" ]; then \
		exit 1 ; \
	fi
endif
	docker build -t $(BUILD_CONTAINER_IMAGE) -f $(DOCKERFILE) dockerfiles/builder

build-container-start:
	$(Q)docker run --rm -d --name $(BUILD_CONTAINER) -v /opt:/opt:shared -v $(HOME):$(HOME):shared -it $(BUILD_CONTAINER_IMAGE) /bin/bash
	$(Q)docker exec -u 0:0 -it $(BUILD_CONTAINER) useradd -s /bin/bash -u $(shell id -u) -c "" $(shell id -un)
	$(Q)docker exec -u 0:0 -it $(BUILD_CONTAINER) ln -s /folk/$(shell id -un) /home/$(shell id -un)

build-container-shell:
	$(Q)docker exec -u $(shell id -u):$(shell id -g) -w $(shell pwd) -e HOME=$(HOME) -e LANG=en_US.UTF-8 -e SSH_AUTH_SOCK=$(SSH_AUTH_SOCK) -it $(BUILD_CONTAINER) /bin/bash

build-container-root-shell:
	$(Q)docker exec -u 0:0 -w $(shell pwd) -e HOME=$(HOME) -e LANG=en_US.UTF-8 -e SSH_AUTH_SOCK=$(SSH_AUTH_SOCK) -it $(BUILD_CONTAINER) /bin/bash

build-container-stop:
	$(Q)docker kill $(BUILD_CONTAINER)

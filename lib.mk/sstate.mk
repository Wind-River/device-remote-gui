# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

SSTATE_LOCAL_DIR  ?= $(TOP)/build/build/sstate-cache
SSTATE_MIRROR_DIR ?= /opt/installs/drg/wrlinux-21/sstate-mirror

help:: sstate.help

sstate.help:
	$(Q)echo -e "\n--- sstate ---"
	$(Q)echo -e "sstate-update             : update $(SSTATE_MIRROR_DIR) with contents from $(SSTATE_LOCAL_DIR)"

sstate-update:
ifdef SSTATE_MIRROR_DIR
	$(Q)find $(SSTATE_LOCAL_DIR) -type l -delete
	$(Q)find $(SSTATE_LOCAL_DIR) -type f -name "*.done" -delete
	$(Q)cp -r $(SSTATE_LOCAL_DIR)/* $(SSTATE_MIRROR_DIR)
	$(Q)find $(SSTATE_MIRROR_DIR) -user $(shell id -u) -exec chmod go+w {} \;
else
	$(error SSTATE_MIRROR_DIR is not defined)
endif

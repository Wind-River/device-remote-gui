# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

# Use this function to cache a git repo in yocto download style
# Used in top Makefile to cache repos used before yocto build
# process take over.

define gitcache
	gitbase=$(shell echo $(1) | sed -nr 's#.*://##p' | tr / .) ; \
	if [ ! $(DOWNLOADS_CACHE) ]; then \
		git clone $(1) $(2) ; \
	elif [ -d $(DOWNLOADS_CACHE)/git2/$$gitbase ]; then \
		git -C $(DOWNLOADS_CACHE)/git2/$$gitbase remote update ; \
		git clone $(DOWNLOADS_CACHE)/git2/$$gitbase $(2) ; \
		git -C $(2) remote add upstream $(1) ; \
	else \
		mkdir -p $(DOWNLOADS_CACHE)/git2 ; \
		git -C $(DOWNLOADS_CACHE)/git2 clone --bare $(1) $$gitbase ; \
		git clone $(DOWNLOADS_CACHE)/git2/$$gitbase $(2) ; \
		git -C $(2) remote add upstream $(1) ; \
	fi
endef


# Default settings
HOSTNAME 	:= $(shell hostname)
USER		:= $(shell whoami)
TOP             := $(shell pwd)
SHELL           := /bin/bash

all: containers images

help::

# Optional configuration
-include hostconfig-$(HOSTNAME).mk
-include userconfig-$(USER).mk
-include lib.mk/*.mk

# Define V=1 to echo everything
V ?= 0
ifneq ($(V),1)
	Q=@
endif

RM = $(Q)rm -f

REL ?= WRLINUX_10_19_LTS_RCPL0002

MACHINES += genericx86-64
#MACHINES += qemuarm64

DISTRO=wrlinux

#IMAGE += wrlinux-image-glibc-std
#IMAGES += wrlinux-image-glibc-small
CONTAINERS += wr-app-container-image-mi-website
CONTAINERS += wr-app-container-image-mi-simulator

JS_URL = https://gitlab.com/saxofon/meta-javascripts.git
JS_REL = 4d77bffa9b7dcb9bd9f98201d48a1d065d89e41c
LAYERS += $(TOP)/build/layers/meta-javascripts

MI_URL = https://gitlab.com/saxofon/meta-marine-instruments.git
MI_REL = fb44af8b963fa13df81c4d5302405508e55ec91f
LAYERS += $(TOP)/build/layers/meta-marine-instruments

WRLS_OPTS += --dl-layers
WRLS_OPTS += --no-recommend
WRLS_OPTS += --accept-eula yes
WRLS_OPTS += --distros $(DISTRO)

# Option "--machines" do two things
#  1. add different layers according to the machines specified.
#  2. sets MACHINE in local.conf to the first one in the list.
# Important to understand, it doesn't build for multiple machines.
WRLS_OPTS += --machines $(MACHINES)

$(TOP)/build/layers/meta-javascripts:
	$(Q)$(call gitcache, $(JS_URL), $@)
	$(Q)git -C $@ checkout $(JS_REL)

$(TOP)/build/layers/meta-marine-instruments:
	$(Q)$(call gitcache, $(MI_URL), $@)
	$(Q)git -C $@ checkout $(MI_REL)

.PHONY: build
build:
	$(Q)if [ ! -d $@ ]; then \
		mkdir -p $@ ; \
		cd $@ ; \
		git clone --branch $(REL) $(WRL)/wrlinux-x wrlinux-x ; \
		REPO_MIRROR_LOCATION=$(WRL) ./wrlinux-x/setup.sh $(WRLS_OPTS) ; \
	fi

.PHONY: build/build
build/build: build $(LAYERS)
	$(Q)if [ ! -d $@ ]; then \
		cd build ; \
		source ./environment-setup-x86_64-wrlinuxsdk-linux ; \
		source ./oe-init-build-env ; \
		bitbake-layers add-layer -F $(LAYERS) ; \
		sed -i /^MACHINE/d conf/local.conf ; \
		sed -i /^BB_NO_NETWORK/d conf/local.conf ; \
	fi

images: build/build
	$(foreach MACHINE,$(MACHINES),$(call bitbake,$(MACHINE),$(IMAGES));)

containers: build/build
	$(foreach MACHINE,$(MACHINES),$(call bitbake,$(MACHINE),$(CONTAINERS));)

clean:
	$(RM) -r build/build

distclean:
	$(RM) -r build

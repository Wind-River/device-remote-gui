help:: bitbake.help

bitbake.help:
	$(Q)echo -e "\n--- bitbake ---"
	$(Q)echo -e "bbs                       : start a bitbake shell to testdrive things manually"

define bitbake
	export MACHINE=$(1) ; \
	if [ -d build ]; then \
		cd build ; \
		source ./environment-setup-x86_64-wrlinuxsdk-linux ; \
		source ./oe-init-build-env ; \
	fi ; \
	bitbake $(2)
endef

define bitbake-task
	export MACHINE=$(1) ; \
	if [ -d build ]; then \
		cd build ; \
		source ./environment-setup-x86_64-wrlinuxsdk-linux ; \
		source ./oe-init-build-env ; \
	fi ; \
	bitbake $(2) -c $(3)
endef

bbs: build/build
	$(Q)cd build ; \
	export MACHINE=$(word 1,$(MACHINES)); \
	source ./environment-setup-x86_64-wrlinuxsdk-linux ; \
	source ./oe-init-build-env ; \
	bash || true

help:: sdk-help

sdk-help:
	$(Q)echo -e "\n--- sdk ---"
	$(Q)echo -e "sdk                       : builds a sdk"
	$(Q)echo -e "esdk                      : builds a esdk"
	$(Q)echo -e "sdk-install               : installs the sdk"
	$(Q)echo -e "sdk-clean                 : removes any installed sdk"

SDK_FILE=$(TOP)/build/build/tmp-glibc/deploy/sdk/*-sdk.sh
SDK_ENV=$(TOP)/build/sdk/environment-setup-*

sdk: build/build
	$(call bitbake-task,$(MACHINE),$(IMAGE),populate_sdk)

esdk: build/build
	$(call bitbake-task,$(MACHINE),$(IMAGE),populate_sdk_ext)

sdk-install:
	$(SDK_FILE) -y -d $(TOP)/build/sdk
	$(MAKE) -C $(TOP)/build/sdk/sysroots/*-wrs-linux/usr/src/kernel scripts

sdk-clean:
	$(Q)$(RM) -r $(TOP)/build/sdk

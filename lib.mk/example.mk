# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

MIS_URL=$(TOP)/build/build/tmp/deploy/images/genericx86-64/oci-simulator-genericx86-64.tar.bz2
MIW_URL=$(TOP)/build/build/tmp/deploy/images/genericx86-64/oci-dashboard-genericx86-64.tar.bz2

help:: example-help

example-help:
	$(Q)echo -e "\n--- example ---"
	$(Q)echo -e "example-import-images     : import container images to storage"
	$(Q)echo -e "example-start             : starts the two microservices (containers) that the example consist of"
	$(Q)echo -e "example-stop              : ends example run"
	$(Q)echo -e "example-delete-images     : delete container images from storage"

example-import-images:
	podman import -c 'ENTRYPOINT ["/usr/sbin/lighttpd", "-f", "/etc/lighttpd.conf", "-D"]' $(MIW_URL) wrl-mi/dashboard
	podman import -c 'ENTRYPOINT ["/usr/bin/mi-simulator"]' $(MIS_URL) wrl-mi/simulator

example-start:
	podman container run --rm -d -p 4444:4444 --name=simulator docker.io/wrl-mi/simulator
	podman container run --rm -d -p 4480:80 --name=dashboard docker.io/wrl-mi/dashboard
	@echo "Browse to http://$(shell hostname -f):4480/mi.html"

example-stop:
	podman stop dashboard
	podman stop simulator

example-delete-images:
	podman image rm wrl-mi/dashboard
	podman image rm wrl-mi/simulator

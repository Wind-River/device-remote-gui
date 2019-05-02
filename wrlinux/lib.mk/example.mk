MIS_URL=$(TOP)/build/build/tmp-glibc/deploy/images/qemux86-64/wr-app-container-mi-simulator-qemux86-64.tar.bz2
MIW_URL=$(TOP)/build/build/tmp-glibc/deploy/images/qemux86-64/wr-app-container-mi-website-qemux86-64.tar.bz2

help:: example-help

example-help:
	$(Q)echo -e "\n--- example ---"
	$(Q)echo -e "example-import-images     : import container images to docker storage"
	$(Q)echo -e "example-start             : starts the two microservices (containers) that the example consist of"
	$(Q)echo -e "example-stop              : ends example run"
	$(Q)echo -e "example-delete-images     : delete container images from docker storage"
example-import-images:
	cat $(MIW_URL) | docker import -c 'ENTRYPOINT ["/usr/sbin/lighttpd", "-f", "/etc/lighttpd.conf", "-D"]' - wrl-mi/website
	cat $(MIS_URL) | docker import -c 'ENTRYPOINT ["/usr/bin/mi-simulator"]' - wrl-mi/simulator

example-start:
	docker-compose -f examples/docker-compose.yml up -d
	@echo "Browse to http://$(shell hostname -f):4480/mi.html"

example-stop:
	docker-compose -f examples/docker-compose.yml down

example-delete-images:
	docker rmi wrl-mi/website
	docker rmi wrl-mi/simulator

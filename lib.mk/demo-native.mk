# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

DEMOIMAGE := $(TOP)/build/build/tmp-glibc/deploy/images/qemux86-64/wrlinux-image-std-sato-qemux86-64.hddimg

#QEMU_OPTS += -enable-kvm
QEMU_OPTS += -cpu qemu64,+ssse3,+sse4.1,+sse4.2,+x2apic 
QEMU_OPTS += -m 2000
#QEMU_OPTS += -full-screen
#QEMU_OPTS += -display sdl,gl=on
#QEMU_OPTS += -display gtk,gl=on
QEMU_OPTS += -usbdevice tablet
QEMU_OPTS += -nographic
QEMU_OPTS += -vnc :3
QEMU_OPTS += -serial mon:stdio
#QEMU_OPTS += -device virtio-rng
QEMU_OPTS += -netdev type=user,id=h1,hostfwd=::4222-:22
QEMU_OPTS += -device e1000,netdev=h1
QEMU_OPTS += -drive file=$(DEMOIMAGE),if=virtio

demo-qemux86-64-native-start:
	stty -onlcr ; qemu-system-x86_64 $(QEMU_OPTS) ; stty onlcr

demo-qemux86-64-native-ssh:
	ssh -p 4222 -L4280:localhost:80 -L4444:localhost:4444 root@localhost

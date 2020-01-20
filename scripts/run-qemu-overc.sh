#!/bin/bash
# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

stty -onlcr

build/build/tmp/sysroots/x86_64/usr/bin/qemu-system-x86_64 -drive file=build/build/boot.img,if=virtio -m 2000 -nographic -vnc :3 -serial mon:stdio -device virtio-rng -cpu qemu64,+ssse3,+sse4.1,+sse4.2,+x2apic \
-netdev \
type=user,id=h1,hostfwd=tcp::4440-10.0.2.15:22,hostfwd=tcp::\
4441-10.0.2.15:2222,hostfwd=tcp::8080-10.0.2.15:8080,hostfwd=tcp::4480-10.0.2.15:4480,hostfwd=tcp::4444-10.0.2.15:4444 \
-device e1000,netdev=h1,mac=00:55:55:01:01:01

stty onlcr
#reset

#!/bin/bash

stty -onlcr

$PWD/tmp/sysroots/x86_64/usr/bin/qemu-system-x86_64 -drive file=boot.img,if=virtio -m 2000 -nographic -vnc :3 -serial mon:stdio -device virtio-rng -cpu qemu64,+ssse3,+sse4.1,+sse4.2,+x2apic

stty onlcr
reset

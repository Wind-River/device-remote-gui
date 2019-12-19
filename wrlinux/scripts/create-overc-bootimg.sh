#!/bin/bash

export PATH=$PWD/tmp/sysroots/x86_64/usr/bin:$PWD/tmp/sysroots/x86_64/usr/sbin:$PATH

sudo ../overc-installer/sbin/cubeit \
	--disk-size 15G --force --config `pwd`/image-live.sh \
	--artifacts `pwd`/tmp/deploy/images/genericx86-64 boot.img


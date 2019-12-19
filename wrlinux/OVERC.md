s manual steps needed for building overc boot.img

# first build the containers, overc components and such
```
[phallsma@arn-build3 wrlinux]$ make
```

# start a bitbake shell
```
[phallsma@arn-build3 wrlinux]$ make bbs
```

# create dependencies
```
[phallsma@arn-build3 build]$ bitbake grub-native jq-native parted-native dosfstools-native qemu-system-native btrfs-tools-native
```

# build sysroots
```
[phallsma@arn-build3 build]$ bitbake build-sysroots
```

# copy tools
```
[phallsma@arn-build3 build]$ cp ../layers/wrlinux/wrlinux-overc/bin/* .
```

# fix autoinstall/autostart of custom containers

Edit image-live.sh and add to HDINSTALL_CONTAINERS :

```
  ${ARTIFACTS_DIR}/oci-simulator-${INSTALL_BSP}.tar.bz2:net=2:app=/usr/bin/mi-simulator \
  ${ARTIFACTS_DIR}/oci-dashboard-${INSTALL_BSP}.tar.bz2:net=2:app=/usr/sbin/lighttpd,-f,/etc/lighttpd.conf,-D \
```

# build
```
[phallsma@arn-build3 build]$ sudo PATH=$PWD/tmp/sysroots/x86_64/usr/bin:$PWD/tmp/sysroots/x86_64/usr/sbin:$PATH ../overc-installer/sbin/cubeit --disk-size 15G --force --config `pwd`/image-live.sh --artifacts `pwd`/tmp/deploy/images/genericx86-64 boot.img
```

# run
```
[phallsma@arn-build3 build]$ stty -onlcr ; $PWD/tmp/sysroots/x86_64/usr/bin/qemu-system-x86_64 -drive file=boot.img,if=virtio -m 2000 -nographic -vnc :3 -serial mon:stdio -device virtio-rng -enable-kvm -cpu qemu64,+ssse3,+sse4.1,+sse4.2,+x2apic; stty onlcr ; reset
```



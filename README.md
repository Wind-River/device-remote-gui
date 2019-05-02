# device-remote-gui

This repository showcases creation of remote GUI for wrlinux and vxwork devices.
The basic mechanism used is client(s) connected via network (wifi, wired, ...) that
could be laptop, tablet, mobile or so and browsing to the target.
At least for linux, same design could easily be reused for local gui by mere adding
of a web renderer (webkit).
In addition to the webpage(s), some communication channel to/from target is needed.
The wrlinux example uses websocket and protobuf.

# wrlinux port

The overall design in wrlinux is based on two containers, one for the web content
including a simple webserver (lighttpd), the other is for sending/recieving data.
Both of these are created via wrlinux image builds.
There is example makefile targets for importing, start/stop etc of these containers
in a docker container engine.

# vxworks port

TODO...

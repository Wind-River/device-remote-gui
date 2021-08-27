# Example platform setup for building GUI with wrlinux

![here it is supposed to be an image of the dashboard view](docs/dashboard.png)

This repository showcases creation of remote GUI for wrlinux devices, as the example above.
The basic mechanism used is client(s) connected via network (wifi, wired, ...) that
could be laptop, tablet, mobile or so and browsing to the target.
At least for linux, same design could easily be reused for local gui by mere adding
of a web renderer (webkit) into the platform and starting a local browser on boot.
In addition to the webpage(s), some communication channel to/from browser/device is
needed and here we use websocket and protobuf to implement this.

The overall design

* a dashboard containing GUI server (via lighttpd, html5 files, javascripts, websocket, protobuf etc)
* sensordata that feeds the GUI client with new data (named simulator as it is simulated sensor data)
  as well is receiving data from the GUI client.

![picture](docs/overview.png)

With this scheme, it gets very flexible to implement a complete system.
The different parts (sensordata, dashboard and client) could all run on same box,
for a standalone system, or they could be split between a server
(running sensordata/dashboard) and a client (smart display, tablet, mobile,
laptop ...) that connects to it.
With the latter approach and also having the server as a cluster, we could make
interesting redundant high availability systems via cheap off-the-shelf SBC's.
The different parts can also be developed with different teams and/or release cycles
if needed, as the interface is neatly contained in a protobuf scheme.

By basing the GUI on HTML5, javascripts and such, we enable it to be implemented
via easily found contractors and/or own resources as it is quite the hype of modern
GUI standards (at least as of 2020 when this was written :) ) and also enables
the GUI to be local on device and/or remotely accessed.

## configuring
* update location of where a wrlinux mirror is installed in your host
  usually means making a hostconfig-<hostname>.mk file that sets WRL

```bash
[phallsma@arn-phallsma-l4 device-remote-gui]$ cat hostconfig-arn-build3.mk 
WRL := /wr/installs/wrl-19-mirror
[phallsma@arn-phallsma-l4 device-remote-gui]$
```

* update location of where you want your download/sstate cache
  usually means making a hostconfig-<hostname>.mk file, or possibly a
  userconfig-<username>.mk file, that sets 

```bash
[phallsma@arn-phallsma-l4 device-remote-gui]$ cat userconfig-phallsma.mk 
DOWNLOADS_CACHE     := /opt/phallsma/yocto/downloads
SSTATE_MIRROR       := /opt/phallsma/yocto/sstate-mirror
[phallsma@arn-phallsma-l4 device-remote-gui]$
```

## building
The Makefile is setup to build CONTAINERS and IMAGES for MACHINES when running
```bash
[phallsma@arn-phallsma-l4 device-remote-gui]$ make
...
[phallsma@arn-phallsma-l4 device-remote-gui]$
```
MACHINES is a list of MACHINE defines and CONTAINERS/IMAGES is a list of
recipes that is defined in layers. Here we have a simple example of some
marine electronic devices made in a layer
https://gitlab.com/saxofon/meta-marine-instruments.git
That is added to our default image :

```bash
[phallsma@arn-ps-tuxlab device-remote-gui]$ cat layers/meta-project-addons/recipes-base/images/wrlinux-image-std.bbappend 
# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

IMAGE_INSTALL += "mi-dashboard"
IMAGE_INSTALL += "mi-simulator"
[phallsma@arn-ps-tuxlab device-remote-gui]$ 
```

## Running
When booted, the webserver and simulator is started automatically by systemd.
So we browse to target, http://<targetip>:80/mi.html, to view the result :
```
![here it is supposed to be an image of the dashboard view](docs/dashboard.png)

As this is just an example, we take some shortcuts...
First press the "Simulator enable" button on the left control pad.
This sets the protobuf variable "simulator" to on, which will generate some
wind etc for our demo.
We can now activate the autopilot (button with "AP:" in middle) and set a course
with the inner compass marker. Also pressing different lights on/off via the right pad.

## Misc

As well as showing a possible way to implement a GUI for wrlinux, this repo also shows

* a neat project setup when using wrlinux (the top Makefile, host/user configs plus lib.mk/*) that
  enables a platform to be built from scratch automatically, on different hosts. Developers, nightly builds etc
  all use same repo and essentially a single git clone + make would be enough.

* as the remote gui is based on HTML5 it is easy to use same as local gui, for example with kioskmode
  on chromium as this project demonstrates as well.

## Legal notices

### Project license
All files in this repository is BSD-3-Clause licensed unless otherwised stated.

### Attribution
This example platform makes use of :

* WRLinux LTS 21 from Windriver
https://www.windriver.com/products/linux

* meta-javascripts - https://gitlab.com/saxofon/meta-javascripts
  Collection of javascripts for use in embedded linux projects built via yocto.
  This platform then uses these recipes in that layer :
  * closure - https://github.com/google/closure-library
    Google's common JavaScript library.

  * protobuf - https://github.com/google/protobuf
    Protocol Buffers - Google's data interchange format.

  * two.js - https://github.com/jonobr1/two.js
    A renderer agnostic two-dimensional drawing api for the web.

* meta-marine-instruments - https://gitlab.com/saxofon/meta-marine-instruments
  Collection of marine software for use in embedded linux projects built via yocto.
  This platform uses this as an example of GUI component implementation.

All product names, logos, and brands are property of their respective owners.
All company, product and service names used in this software are for identification
purposes only. Wind River is a registered trademark of Wind River Systems, Inc.

Disclaimer of Warranty / No Support: Wind River does not provide support and
maintenance services for this software, under Wind River’s standard Software
Support and Maintenance Agreement or otherwise. Unless required by applicable
law, Wind River provides the software (and each contributor provides its
contribution) on an “AS IS” BASIS, WITHOUT WARRANTIES OF ANY KIND, either
express or implied, including, without limitation, any warranties of TITLE,
NONINFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE.
You are solely responsible for determining the appropriateness of using or
redistributing the software and assume any risks associated with your
exercise of permissions under the license.

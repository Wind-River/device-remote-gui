# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

STARTING-URL_pn-wr-kiosk = "http://localhost:80"
WINDOW-SIZE_pn-wr-kiosk = "1920,1080"
#KIOSK-MODE-FLAG_append_pn-wr-kiosk = ""
PACKAGECONFIG_remove_pn-wr-kiosk = "vkeyboard"

do_install_append() {
   cat<<EOF>${D}/usr/libexec/wr-chromium-web-kiosk.sh
#!/bin/sh

# setting default display for chromium
export DISPLAY=:0

# Force change resolution
(sleep 2 ; xrandr -s 1920x1080)&
chromium --kiosk --start-maximized \
    --load-extension="" \
    --window-size=1920,1080 \
    http://localhost:80
EOF
}

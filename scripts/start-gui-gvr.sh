# Copyright (c) 2021 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

google-chrome --window-size=1920,500 http://localhost:6080 >chrome.log 2>&1 &

vncviewer -geometry=1920x400 -RemoteResize :6 >vnc.log 2>&1 &
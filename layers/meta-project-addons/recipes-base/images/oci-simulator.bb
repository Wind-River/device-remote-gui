# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

SUMMARY = "Application container for mi-simulator"
DESCRIPTION = "An application container which will run mi-simulator"

inherit wr-app-container

IMAGE_INSTALL += "mi-simulator"

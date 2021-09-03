#!/bin/sh
# Copyright (c) 2021 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

INSTANCE=gvr.wrstudio.cloud

SERVICE=$(MY_STUDIO=$INSTANCE studio-cli hive showssh | grep ^ssh | awk '{print $8}')

ssh -o StrictHostKeychecking=no $INSTANCE -p 2222 \
  -L 5906:localhost:5906 -L 6080:localhost:6080 -L 6022:localhost:6022 \
  -l $SERVICE



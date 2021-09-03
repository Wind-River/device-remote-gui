#!/bin/sh
# Copyright (c) 2021 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

INSTANCE=training.wrstudio.cloud

SERVICE=$(MY_STUDIO=$INSTANCE studio-cli hive showssh | grep ^ssh | awk '{print $8}')

ssh -o StrictHostKeychecking=no $INSTANCE -p 2222 \
  -L 5905:localhost:5905 -L 5080:localhost:5080 -L 5022:localhost:5022 \
  -l $SERVICE

#!/bin/bash

# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

# This script is referenced in WRStudio wrlinux build parameters as PRE_BUILD
# ${GITLAB_URL}phallsma/device-remote-gui/raw/master/scripts/wrstudio-pre-build.sh		
# (where ENV could be like training.wrstudio.cloud or similar)

# Verbose logging
set -x

git clone --single-branch --branch master ${GITLAB_URL}/phallsma/device-remote-gui.git
git clone --single-branch --branch master ${GITLAB_URL}/phallsma/meta-javascripts.git
git checkout 9a0c97e935a8bc4e17a62baa7f619ff5aa295742
git clone --single-branch --branch master ${GITLAB_URL}/phallsma/meta-marine-instruments.git
git checkout 9ab86ccb5f3c7b429badcf8d9563b32c50582a01

bitbake-layers add-layer -F $PWD/device-remote-gui/layers/meta-project-addons \
                            $PWD/meta-javascripts \
                            $PWD/meta-marine-instruments

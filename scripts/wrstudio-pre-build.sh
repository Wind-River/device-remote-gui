#!/bin/bash

# This script is referenced in WRStudio wrlinux build parameters as PRE_BUILD
# ${GITLAB_URL}phallsma/device-remote-gui/raw/master/scripts/wrstudio-pre-build.sh		
# (where ENV could be like training.wrstudio.cloud or similar)

# Verbose logging
set -x

git clone --single-branch --branch master ${GITLAB_URL}/phallsma/device-remote-gui.git
git clone --single-branch --branch master ${GITLAB_URL}/phallsma/meta-javascripts.git
git clone --single-branch --branch master ${GITLAB_URL}/phallsma/meta-marine-instruments.git

bitbake-layers add-layer -F $PWD/device-remote-gui/layers/meta-project-addons \
                            $PWD/meta-javascripts \
                            $PWD/meta-marine-instruments

# Copyright (c) 2020 Wind River Systems, Inc.
# SPDX-License-Identifier: BSD-3-Clause

all: overview.png

%.png: %.dot
	dot -Tpng $< -o $@

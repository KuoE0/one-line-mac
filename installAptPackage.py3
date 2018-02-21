#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Filename: installAptPackage.py3
# Author:   KuoE0 <kuoe0.tw@gmail.com>
#
# Copyright (C) 2018
#
# Distributed under terms of the MIT license.

"""

"""

import json
import os

with open('apt.json') as f:
    package_list = json.load(f)
    package_list = ' '.join([p['name'] for p in package_list])
    cmd = ' '.join(['sudo', 'apt', 'install', package_list])
    os.system(cmd)

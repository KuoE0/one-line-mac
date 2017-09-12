#!/usr/bin/env ruby
#
# Copyright (C) 2017 KuoE0 <kuoe0.tw@gmail.com>
#
# Distributed under terms of the MIT license.

require 'json'

def run_system_cmd(cmd)
    puts cmd
    system(cmd)
end

def install_mas_application(filename)
    app_file = File.read(filename) # read file
    app_list = JSON.parse(app_file) # parse JSON
    for app in app_list
        id = app["id"]
		# run install command
		cmd = ['mas', 'install', id].join(' ')
		run_system_cmd(cmd)
    end
end

install_mas_application('mas.json')

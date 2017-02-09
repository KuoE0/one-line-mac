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

def run_brew_tap(tap_list)
	for tap in tap_list
		cmd = "brew tap #{tap}"
		run_system_cmd(cmd)
	end
	run_system_cmd("brew update")
end

def run_brew_install(pkg_name, pkg_args)
	cmd_list = ['brew', 'install', pkg_name]
	if !pkg_args.nil?
		cmd_list.push(*pkg_args)
	end
	cmd = cmd_list.join(' ')
	run_system_cmd(cmd)
end

def run_brew_cask_install(pkg_name, pkg_args)
	cmd_list = ['brew', 'cask', 'install', pkg_name]
	if !pkg_args.nil?
		cmd_list.push(*pkg_args)
	end
	cmd = cmd_list.join(' ')
	run_system_cmd(cmd)
end

run_system_cmd("brew update")

tap_list = ["caskroom/cask", "caskroom/versions", "caskroom/fonts"]
run_brew_tap(tap_list)

message_list = Hash.new

# Install command line tools from Homebrew
brew_package_file = File.read('brew.json') # read file
brew_package_list = JSON.parse(brew_package_file) # parse JSON
brew_package_list = brew_package_list.sort_by { |f| f["name"] } # sort

for pkg in brew_package_list
	name = pkg["name"]
	args = pkg["args"]
	do_before = pkg["do_before"]
	do_after = pkg["do_after"]
	message = pkg["message"]

	if !do_before.nil?
		for cmd in do_before
			run_system_cmd(cmd)
		end
	end
	run_brew_install(name, args)
	if !do_after.nil?
		for cmd in do_after
			run_system_cmd(cmd)
		end
	end

	if !message.nil?
		message_list[name] = message
	end
end

# Install macOS applications from Homebrew
cask_package_file = File.read('brew-cask.json') # read file
cask_package_list = JSON.parse(cask_package_file) # parse JSON
cask_package_list = cask_package_list.sort_by { |f| f["name"] } # sort
for pkg in cask_package_list
	name = pkg["name"]
	args = pkg["args"]
	do_before = pkg["do_before"]
	do_after = pkg["do_after"]
	message = pkg["message"]

	if !do_before.nil?
		for cmd in do_before
			run_system_cmd(cmd)
		end
	end
	run_brew_cask_install(name, args)
	if !do_after.nil?
		for cmd in do_after
			run_system_cmd(cmd)
		end
	end

	if !message.nil?
		message_list[name] = message
	end
end

message_list.keys.each do |pkg_name|
	puts "=== Note for #{pkg_name} ==="
	message_list[pkg_name].each { |msg| puts msg }
end

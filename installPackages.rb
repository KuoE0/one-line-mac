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

def install(install_func, filename)
    message_list = Hash.new
    package_file = File.read(filename) # read file
    package_list = JSON.parse(package_file) # parse JSON
    package_list = package_list.sort_by { |f| f["name"] } # sort
    for pkg in package_list
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
        install_func.call(name, args)
        if !do_after.nil?
            for cmd in do_after
                run_system_cmd(cmd)
            end
        end

        if !message.nil?
            message_list[name] = message
        end
    end

    return message_list
end

def run_brew_tap(tap_list)
    for tap in tap_list
        cmd = "brew tap #{tap}"
        run_system_cmd(cmd)
    end
    run_system_cmd("brew update")
end

def run_brew_install(pkg_name, pkg_args)
    # use `reinstall` to ignore previously install for dependency
    cmd_list = ['brew', 'reinstall', pkg_name]
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

def run_pip3_install(pkg_name, pkg_args)
    cmd_list = ['pip3', 'install', pkg_name]
    if !pkg_args.nil?
        cmd_list.push(*pkg_args)
    end
    cmd = cmd_list.join(' ')
    run_system_cmd(cmd)
end

run_system_cmd("brew update")

tap_list = ["caskroom/cask", "caskroom/versions", "caskroom/fonts", "neovim/neovim"]
run_brew_tap(tap_list)

message_list = Hash.new

message_list = message_list.merge(install(method(:run_brew_install), 'brew.json'))
message_list = message_list.merge(install(method(:run_brew_cask_install), 'brew-cask.json'))
message_list = message_list.merge(install(method(:run_pip3_install), 'pip3.json'))

message_list.keys.each do |pkg_name|
    puts "=== Note for #{pkg_name} ==="
    message_list[pkg_name].each { |msg| puts msg }
end

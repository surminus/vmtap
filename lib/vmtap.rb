require 'yaml'
require 'trollop'
require 'droplet_kit'
require 'randexp'
require 'pry'

require_relative 'modify'
require_relative 'collect'

unless global_opts[:config_file]
  vmspec = YAML.load_file('vms/default.yaml')
end

region = vmspec[:region]
image  = vmspec[:image]
size   = vmspec[:size]

modify = Vmtap::Modify.new
collect = Vmtap::Collect.new

case cmd
  when 'create'
    unless name = cmd_opts[:name]
      puts "No name specified, generating..."
      name = /\w{8}/.gen
    end

  vm.create(name, region, image, size)

  when 'delete'
    force = cmd_opts[:force]
    if cmd_opts[:all]
      modify.delete_all
    else
      name = cmd_opts[:name]
      modify.delete(name, force)
    end

  when 'inventory'
    collect.inventory

  else
    abort("Unrecognised command")
end

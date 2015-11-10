require 'yaml'
require 'trollop'
require 'droplet_kit'
require 'randexp'
require 'pry'

require_relative 'modify'
require_relative 'collect'

SUB_COMMANDS = %w(create delete info)
global_opts = Trollop::options do
  banner <<-EOS
  vmtap is used to quickly spin up droplets using the excellent
  API: https://github.com/digitalocean/droplet_kit

  Usage: vmtap command [opts]

  Commands:
    create
    delete
    info

  Options:
  EOS

  stop_on SUB_COMMANDS
end

cmd = ARGV.shift

cmd_opts = case cmd
  when 'create'
    Trollop::options do
      opt :name, "Specify name of VM", :type => :string
      opt :file, "Specify different config file for VM specs", :type => :string
    end
  when 'delete'
    Trollop::options do
      opt :name, "Specify name of VM", :type => :string
      opt :force, "Force delete"
      opt :all, "Delete ALL machines"
    end

  when 'inventory'
  else
    Trollop::die "Unknown command #{cmd.inspect}"
end

creds_file = YAML.load_file('config/creds.yaml')

unless token = creds_file[:token] or token = ENV['OCEAN_TOKEN']
  abort("Error: Set OCEAN_TOKEN environment variable")
end

$client = DropletKit::Client.new(access_token: token)

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

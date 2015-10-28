require 'yaml'
require 'trollop'
require 'droplet_kit'
require 'randexp'

global_opts = Trollop::options do
  banner <<-EOS
  vmtap is used to quickly spin up droplets using the excellent
  API: https://github.com/digitalocean/droplet_kit

  Usage: vmtap [opts] command

  Commands:
    create
    delete
    info
    reboot
    shutdown
    poweron

  Options:
  EOS

  opt :name, "Name of VM", :type => :string
  opt :id, "ID of VM", :type => :int
end

cmd = ARGV.shift

raise "Error: require argument" unless cmd

token = ENV['OCEAN_TOKEN']
unless token
  raise "Set OCEAN_TOKEN environment variable"
end
client = DropletKit::Client.new(access_token: token)

vmspec = YAML.load_file('config/vmspec.yaml')

config_default = vmspec["default"]
config_region = config_default[:region]
config_image  = config_default[:image]
config_size   = config_default[:size]

def create_machine(client, vmname, region, image, size)
  droplet = DropletKit::Droplet.new(name: vmname, region: region, image: image, size: size)
  puts "Creating machine called " + vmname
  client.droplets.create(droplet)
end

def info_machine(client, vmname)
  droplet = client.droplets.find(name: vmname)
end

def info_all(client)
  droplet = client.droplets.all
  puts droplet
end

def delete_machine(client, id)
  puts "Deleting machine called " + vmname
  client.droplets.delete(name: vmname)
end

case cmd
  when 'create'
  unless global_opts[:name]
    puts "Generating random hostname"
    a = /\w{8}/.gen
  else
    a = global_opts[:name]
  end
    create_machine(client, a, config_region, config_image, config_size)

  when 'delete'
    a = global_opts[:name]
    delete_machine(client, a)

  when 'info'
    a = global_opts[:name]
    info_all(client)
end

puts "Done!"

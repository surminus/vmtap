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
  opt :config_file, "Specify different machines specs", :type => :string
end

cmd = ARGV.shift

raise "Error: require argument" unless cmd

token = ENV['OCEAN_TOKEN']
unless token
  raise "Set OCEAN_TOKEN environment variable"
end
$client = DropletKit::Client.new(access_token: token)

unless global_opts[:config_file]
  vmspec = YAML.load_file('config/vmspec.yaml')
end

config_default = vmspec["default"]
config_region = config_default[:region]
config_image  = config_default[:image]
config_size   = config_default[:size]

def create_machine(vmname, region, image, size)
  droplet = DropletKit::Droplet.new(name: vmname, region: region, image: image, size: size)
  puts "Creating machine called " + vmname
  $client.droplets.create(droplet)
end

def find_machine_id(vmname)
  $client.droplets.all.each do |vm|
    if vm.name == vmname
      return vm.id
    end
  end
end

def inventory
  $client.droplets.all.each do |vm|
    puts "---"
    puts "name:    #{vm.name}"
    puts "id:      #{vm.id}"
    puts "ip:      #{vm.ip_address}"
  end
end

def delete_machine(vmname)
  id = find_machine_id(vmname)
  $client.droplets.delete(id: id)
end

case cmd
  when 'create'
    unless global_opts[:name]
      puts "Generating random hostname"
      a = /\w{8}/.gen
    else
      a = global_opts[:name]
    end
    create_machine(a, config_region, config_image, config_size)

  when 'delete'
    a = global_opts[:name]
    delete_machine(a)

  when 'inventory'
    inventory
end
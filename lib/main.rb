require 'yaml'
require 'trollop'
require 'droplet_kit'
require 'randexp'
require 'pry'

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
      opt :name, "Specify name of VM", :type => :string, :required => true
    end

  when 'inventory'
  else
    Trollop::die "Unknown command #{cmd.inspect}"
end

abort("Error: Set OCEAN_TOKEN environment variable") unless token = ENV['OCEAN_TOKEN']

$client = DropletKit::Client.new(access_token: token)

unless global_opts[:config_file]
  vmspec = YAML.load_file('config/default.yaml')
end

region = vmspec[:region]
image  = vmspec[:image]
size   = vmspec[:size]

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
  end
end

def delete_machine(vmname)
  id = find_machine_id(vmname)
  $client.droplets.delete(id: id)
end

case cmd
  when 'create'
    unless name = cmd_opts[:name]
      puts "No name specified, generating..."
      name = /\w{8}/.gen
    end
  create_machine(name, region, image, size)

  when 'delete'
    name = cmd_opts[:name]
    delete_machine(name)

  when 'inventory'
    inventory

  else
    abort("Unrecognised command")
end

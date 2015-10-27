require 'yaml'
require 'trollop'
require 'droplet_kit'
require 'randexp'

opts = Trollop::options do
  opt :name, "Name of VM", :type => :string
end

unless opts[:name]
  puts "Generating random hostname"
  name = /\w{8}/.gen
else
  name = opts[:name]
end

token = ENV['OCEAN_TOKEN']
unless token
  raise "Set OCEAN_TOKEN environment variable"
end

client = DropletKit::Client.new(access_token: token)

vmspec = YAML.load_file('config/vmspec.yaml')
vms = YAML.load_file('config/vms.yaml')

default = vmspec["default"]
region = default[:region]
image  = default[:image]
size   = default[:size]

droplet = DropletKit::Droplet.new(name: name, region: region, image: image, size: size)
puts "Creating machine called " + name
client.droplets.create(droplet)

puts "Done!"

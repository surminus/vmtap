require 'highline/import'
require 'yaml'
require_relative 'collect'

module Vmtap
  class Modify

    def initialize
      Vmtap::Auth.new
    end

    def create(vmname, config_file)

      vmspec = YAML.load_file(config_file)

      region = vmspec[:region]
      image  = vmspec[:image]
      size   = vmspec[:size]

      droplet = DropletKit::Droplet.new(name: vmname, region: region, image: image, size: size)
      puts "Creating machine called " + vmname
      $client.droplets.create(droplet)
      puts "Done!"
    end

    def delete(vmname, force)
      machine = Vmtap::Collect.new
      id = machine.machine_id(vmname)
      puts "Deleting machine: " + vmname
      if !force
        exit unless HighLine.agree('This will completely destroy the machine. Do you wish to continue?')
      end
      $client.droplets.delete(id: id)
      puts "Done!"
    end

    def delete_all
      machines = Vmtap::Collect.new
      all_ids = machines.all_ids_as_array

      exit unless HighLine.agree('This will destroy EVERYTHING! Do you wish to continue?')

      all_ids.each do |a|
        id = a[:id]
        puts "Deleting machine ID: #{id}"
        $client.droplets.delete(id: id)
      end
      puts "Done!"
    end
  end
end

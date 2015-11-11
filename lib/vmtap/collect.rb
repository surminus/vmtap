require_relative 'auth'

module Vmtap
  class Collect

    def initialize
      Vmtap::Auth.new
    end

    def machine_id(vmname)
      $client.droplets.all.each do |vm|
        if vm.name == vmname
          return vm.id
        end
      end
    end

    def all_ids_as_array
      id_array = Array.new
      $client.droplets.all.each do |vm|
        id_array << vm.id
      end
    end

    def inventory
      $client.droplets.all.each do |vm|
        puts "---"
        puts "name:    #{vm.name}"
        puts "id:      #{vm.id}"
      end
    end
  end
end

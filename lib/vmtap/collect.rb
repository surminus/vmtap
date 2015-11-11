require 'yaml'
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

    def inventory(verbose)
      $client.droplets.all.each do |vm|
        if verbose
          puts vm.to_yaml
        else
          puts "#{vm.id}: #{vm.name}"
        end
      end
    end
  end
end

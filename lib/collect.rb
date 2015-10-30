class Collect
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
end


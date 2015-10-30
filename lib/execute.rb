class Execute
  def create(vmname, region, image, size)
    droplet = DropletKit::Droplet.new(name: vmname, region: region, image: image, size: size)
    puts "Creating machine called " + vmname
    $client.droplets.create(droplet)
    puts "Done!"
  end

  def delete(vmname)
    id = find_machine_id(vmname)
    puts "Deleting machine called " + vmname
    $client.droplets.delete(id: id)
    puts "Done!"
  end
end

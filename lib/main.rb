require 'droplet_kit'

token = ENV['OCEAN_TOKEN']
unless token
  raise "Set OCEAN_TOKEN environment variable"
end

client = DropletKit::Client.new(access_token: token)

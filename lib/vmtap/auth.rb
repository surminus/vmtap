require 'yaml'
require 'droplet_kit'

module Vmtap
  class Auth
    def initialize
      creds_file = YAML.load_file('config/creds.yaml')

      unless token = creds_file[:token] or token = ENV['OCEAN_TOKEN']
          abort("Error: No token set")
      end

      $client = DropletKit::Client.new(access_token: token)
    end
  end
end

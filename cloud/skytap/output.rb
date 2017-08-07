#! /usr/bin/env ruby
require 'rest-client'
require 'json'
require 'yaml'

API_TOKEN = ENV['SKYTAP_API_TOKEN']
HEADERS = { 
  :Authorization => API_TOKEN,
  :accept => :json, 
  :content_type => :json
}
URL = 'https://cloud.skytap.com/'
CONFIGURATION_URL = URL + 'configurations/'
DEBUG_OUTPUT = false

def output_classroom(environment_id)
  environment = JSON.parse(RestClient.get( CONFIGURATION_URL + environment_id, HEADERS))


  classroom_info =
    {
      'environment_id' => environment['id'],
      'environment_name' => environment['name'],
      'publish_sets' => [],
      'vms' => []
  }

    environment['publish_sets'].each do |publish_set|
      classroom_info['publish_sets'] << { 'name' => publish_set['name'], 'url' => publish_set['desktops_url'] }
    end

    environment['vms'].each do |vm|
      classroom_info['vms'].push({
        'name' => vm['name'],
        'services' => vm['interfaces'][0]['services']
      })
    end
    return classroom_info
end

# Output the student URLs
puts output_classroom(ARGV[0]).to_yaml

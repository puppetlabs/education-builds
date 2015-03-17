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

def create_publish_set(config_id, vms, set_name)
  vm_set = {
    'name' => set_name,
    'publish_set_type' => 'single_url',
    'vms' => vms
  }
  return JSON.parse(RestClient.post(CONFIGURATION_URL + config_id + '/publish_sets', JSON.generate(vm_set), HEADERS))
end  

def create_base_environment(name, base_template)
  env_config = {
    'template_id' => base_template, 
    'name' => name 
  }
  return JSON.parse(RestClient.post(CONFIGURATION_URL, JSON.generate(env_config), HEADERS))
end

def add_student_vms(environment_id, students, student_template_id, student_vm_id)
  environment = ''
  students.each do |student|
    environment = JSON.parse(RestClient.put( CONFIGURATION_URL + environment_id, { 'template_id' => student_template_id }, HEADERS))
  end
  return environment
end  

def set_vm_name(vm,name)
  RestClient.put( URL + 'vms/' + vm['id'], { 'name' => name }, HEADERS )
  RestClient.put( URL + 'vms/' + vm['id'] + '/interfaces/' + vm['interfaces'][0]['id'], { 'hostname' => name } , HEADERS )
end

def map_vm_ports(vm,ports)
  ports.each do |port|
    unless vm['interfaces'][0]['services'].any? { |vm_port| vm_port['internal_port'] == port }
      RestClient.post( URL + 'vms/' + vm['id'] + '/interfaces/' + vm['interfaces'][0]['id'] + '/services', { 'port' => port } , HEADERS)
    end
  end
end

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

# Load classroom information from yaml file 
classroom = YAML.load(File.read(ARGV[0]))

# Create environment from base base_template_id
environment = create_base_environment(classroom['title'],classroom['master_template_id'])
master_vm_id = environment['vms'][0]['id']

# Provision student machines from student_template_id
environment = add_student_vms(environment['id'],classroom['students'],classroom['student_template_id'],classroom['student_vm_id'])

# Configure student machines hostnames, names, and mapped ports
student_vms = []
all_vms = []
students = classroom['students']
environment['vms'].each do |vm|
  if vm['id'] != master_vm_id then
    student_name = students.pop
    set_vm_name(vm,student_name)
    map_vm_ports(vm,classroom['student_ports'])
    # Add only Student VMs to student publish set
    student_vms.push( { 'vm_ref' => URL + 'vms/' + vm['id'], 'access' => 'use' } )
  else
    set_vm_name(vm,classroom['master_name'])
    map_vm_ports(vm,classroom['master_ports'])
  end
  # Add all vms to Instructor publish set
  all_vms.push( { 'vm_ref' => URL + 'vms/' + vm['id'], 'access' => 'run_and_use' } )
end

# Create published sets for classroom evironment
publish_student_vms = create_publish_set( environment['id'], student_vms, 'Student VMs' )
publish_all_vms = create_publish_set( environment['id'], all_vms, 'Instructor Dashboard' )

# Output the student URLs
puts output_classroom(environment['id']).to_yaml

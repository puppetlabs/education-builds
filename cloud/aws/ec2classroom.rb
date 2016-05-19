#! /usr/bin/env ruby
require 'aws-sdk'
require 'json'
require 'yaml'
require 'inifile'

# Credentials are loaded automatically by the gem
#AWS_CREDENTIALS = IniFile.load("#{ENV['HOME']}/.aws/credentials")["default"] ||
#  { 
#    aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
#    aws_secret_accsss_key => ENV['AWS_SECRET_ACCESS_KEY']
#  }
AWS_CONFIG = IniFile.load("#{ENV['HOME']}/.aws/config")["default"] ||
  { 
    region => ENV['AWS_REGION'],
    output => ENV['AWS_OUTPUT']
  }

# Match names from learndot to shortnames in local config file
COURSE_CODES = YAML.load_file("codes.yaml")

#Take json string as argument
# {
#   "title": "Course Title",
#   "course_id": "Course ID",
#   "description": "Course Description",
#   "start": "Course Start DateTime",
#   "end": "Course End DateTime",
#   "students": {
#     "Student Name": "student@name.com",
#     "Other Student": "other@student.com",
#     "Another One": "another@one.com" 
#   }
# }
case ARGV[0] 
when '-j', '--json'
  COURSE_INFO = JSON.parse(ARGV[1])
when '-f', '--file'
  COURSE_INFO = JSON.parse(File.read(ARGV[1]))
else
  puts "Usage: -j <COURSE_INFO in json string> || -f <path/to/course_info.json>"
  exit 1
end

if ! COURSE_INFO["title"] then raise "Title is required" end
if ! COURSE_INFO["course_id"] then raise "Course ID is required" end
if ! COURSE_INFO["description"] then raise "Description is required" end
if ! COURSE_INFO["start"] then raise "Start date is required" end
if ! COURSE_INFO["end"] then raise "End date is required" end
if ! COURSE_INFO["students"] then raise "Student list is required" end

CODE = COURSE_CODES[COURSE_INFO["title"]]

# Lookup classroom format
# infrastructure.yaml
# ---
# student: 
#   ami: "ami-4236d922"
#   type: "m4.large"
#   key_name: "training"
#   security_groups: "sg-688b120f"
CLASSROOM_FORMAT = YAML.load_file("courses/#{CODE}.yaml")


def create_instance(ec2, image, name)
  resp = ec2.run_instances(
    :min_count                   => 1,
    :max_count                   => 1,
    :image_id                    => image["ami"],
    :instance_type               => image["type"],
    :key_name                    => image["key_name"],
    :security_group_ids          => image["security_group_ids"],
    :block_device_mappings       => [
      :device_name => "/dev/sda1",
      :ebs => {
        :volume_size => 30,
      }
    ]
  )
  instance_id = resp.instances[0][:instance_id]

  ec2.create_tags({
    :resources => [resp.instances[0][:instance_id]],
    :tags => [
      { :key => 'Name',             :value => COURSE_INFO["title"] + " - " + COURSE_INFO["course_id"] + " - " + name },
      { :key => 'Role',             :value => "Virtual Classroom" },
      { :key => 'department',       :value => "EDU" },
      { :key => 'project',          :value => "Virtual Classroom" },
      { :key => 'created_by',       :value => "Automated Classroom Provisioning"},
      { :key => 'termination_date', :value => COURSE_INFO["end"] },
    ]
  })
  
  #Wait a second for public IP to be assigned
  sleep(2)

  return {
    :ip => ec2.describe_instances({ :instance_ids => [instance_id]}).reservations[0].instances[0].public_ip_address,
    :instance_id => instance_id
  }
end

ec2 = Aws::EC2::Client.new(region: AWS_CONFIG["region"])

vms = {}

if CLASSROOM_FORMAT["master"] then
  #Provision classroom master VM
  vms["master"] = create_instance(ec2, CLASSROOM_FORMAT["master"], "master")
  vms["master"][:email] = "education@puppetlabs.com"
end
COURSE_INFO["students"].each do |student_name, student_email|
  if CLASSROOM_FORMAT["student"] then
    # Provision student VMs
    vms[student_name] = create_instance(ec2, CLASSROOM_FORMAT["student"], student_name)
  else
    # Give students the info for the master
    vms[student_name] = vms["master"]
  end
  vms[student_name][:email] = student_email
end

puts vms.to_json

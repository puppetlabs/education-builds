require 'open-uri'

##############################################################
#                                                            #
# Methods to abstract the environment variable CL interface. #
#                                                            #
##############################################################

# If the PE_FAMILY environment variable isn't specified, extract it from the
# the version. If there's no PE_VERSION, this defaults to nil
def pe_family
  ENV["PE_FAMILY"] or ENV["PE_VERSION"] ? ENV["PE_VERSION"].split('.')[0 .. 1].join('.') : nil
end

# Convert the string value 'true' for the PRE_RELEASE environment variable to
# a boolean true.
def pre_release?
  ENV["PRE_RELEASE"] == 'true'
end

# If the PE_VERSION environmnet variable isn't specified, we can fetch the
# latest version data for a pre-release build or use the string 'latest' for
# the latest release version in the specified family.
def pe_version
  ENV["PE_VERSION"] or pre_release? ? latest_pre_version(pe_family) : nil
end

########################################
#                                      #
# Helper methods for installer caching #
#                                      #             
########################################

# At some point we might modify this method to specify dist, release, and arch
def installer_filename
  "puppet-enterprise-#{pe_version}-el-7-x86_64.tar.gz"
end

# Get the latest pre-release version string for a given PE Version family.
def latest_pre_version(pe_family)
  open("http://getpe.delivery.puppetlabs.net/latest/#{pe_family}").read
end

# Public releases are .tar.gz, while internal releases are just tar.
# When cacheing a pre-release, gzip it.
# TODO Use https://s3.amazonaws.com/pe-builds/released/2016.2.0/puppet-enterprise-2016.2.0-el-7-x86_64.tar.gz
def pe_installer_url
  "http://enterprise.delivery.puppetlabs.net/#{pe_family}/ci-ready/#{installer_filename}"
end

# Check if the installer exists and the file isn't empty.
def already_cached?(path)
  File.exist?(path) and File.zero?(path) == false
end

# Download the installer. Curl is nicer than re-inventing the wheel with ruby.
def download_installer
  unless `curl #{pe_installer_url} -o ./file_cache/installers/#{installer_filename}`
    fail "Error downloading the PE installer"
  end
end

###################################
#                                 #
# Helper methods for building VMs #
#                                 #             
###################################

def call_packer(template, args={}, var_file=nil)
  arg_string = ""
  args.each do |k, v|
    arg_string << " -var '#{k}=#{v}' "
  end
  arg_string << " -var-file=#{var_file} " if var_file
  # Call packer and pass everything through to STDOUT live
  IO.popen("packer build #{arg_string} #{template}") { |io| while (line = io.gets) do puts line end }
end

def template_dir
  './templates'
end

def template_file(build_type)
  case build_type
  when 'base'
    File.join(template_dir, 'educationbase.json')
  when 'build'
    File.join(template_dir, 'educationbuild.json')
  when 'student'
    File.join(template_dir, 'student.json')
  else
    fail "ERROR: Invalid build type: #{build_type}"
  end
end

def var_file(vm_name)
  if vm_name == "student"
    nil
  else
    File.join(template_dir, "#{vm_name}.json")
  end
end

def output_dir(vm_name, build_type)
  unless build_type == 'base'
    File.join('./output/', "#{vm_name}-virtualbox")
  else
    File.join('./output/', "#{vm_name}-base-virtualbox")
  end
end

def check_output_dir(vm_name, build_type)
  vm_output_dir = output_dir(vm_name, build_type)
  if File.exists?(vm_output_dir)
    puts "An output directory already exists at #{vm_output_dir}. Would you like to replace it with this build? [y/N]"
    raise "User cancelled" unless [ 'y', 'yes', '' ].include? STDIN.gets.strip.downcase
    #TODO Instead of rm -rf, pass force to packer as default, delete all this stuff
    `rm -rf #{vm_output_dir}`
  end
end

def build_vm(build_type, vm_name, args={})
  check_output_dir(vm_name, build_type)
  call_packer(template_file(build_type), args, var_file(vm_name))
end

#################################################
#                                               #
# Rake tasks for prepping the local environment #
#                                               #             
#################################################

desc "Set up default cache dirctories"
task :set_up_cache_dirs do
  FileUtils.mkdir_p(["./file_cache/gems", "./file_cache/installers", "./output", "./packer_cache"])
end

# TODO Add a task to set up symlinks for file_cache, output, and packer_cache
# then mkdir_p for file_cache/gems and file_cache/installers
# Environment variables for FILE_CACHE_SRC, OUTPUT_SRC, PACKER_CACHE_SRC

desc "Cache the PE Installer"
task :cache_pe_installer do
  cached_installer_path = "./file_cache/installers/#{installer_filename}"
  if not already_cached?(cached_installer_path) 
    puts "Downloading PE installer for #{pe_version}"
    download_installer
  else
    puts "PE Installer for #{pe_version} is already cached. Moving on..."
  end
end

##################
#                #
# VM Build tasks #
#                #             
##################

desc "Training VM base build"
task :training_base => [:cache_pe_installer]do
  build_vm('base', 'training', {'pe_version' => pe_version})
end

desc "Training VM build"
task :training_build do
  build_vm('build', 'training', {})
end

desc "Master VM base build"
task :master_base => [:cache_pe_installer] do
  build_vm('base', 'master', {'pe_version' => pe_version})
end

desc "Master VM build"
task :master_build do
  build_vm('build', 'master', {})
end

desc "Learning VM base build"
task :learning_base => [:cache_pe_installer] do
  build_vm('base', 'learning', {'pe_version' => pe_version})
end

desc "Learning VM build"
task :learning_build do
  build_vm('build', 'learning', {})
end

desc "Student VM build"
task :student_build do
  build_vm('student', 'student', {})
end

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
  "puppet-enterprise-#{pe_version}-el-7-x86_64.tar"
end

# Get the latest pre-release version string for a given PE Version family.
def latest_pre_version(pe_family)
  open("http://getpe.delivery.puppetlabs.net/latest/#{pe_family}").read
end

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

def build_vm(template, args={}, var_file=nil)
  arg_string = ""
  args.each do |k, v|
    arg_string << " -var #{k}=#{v} "
  end
  arg_string << " -var-file=#{var_file} " if var_file
  # Call packer and pass everything through to STDOUT live
  IO.popen("packer build #{arg_string} #{template}") { |io| while (line = io.gets) do puts line end }
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
task :training_base do
  build_vm('./templates/educationbase.json', args={}, var_file='./templates/training.json')
end

desc "Training VM build"
task :training_build do
  build_vm('./templates/educationbuild.json', args={}, var_file='./templates/training.json')
end

desc "Master VM base build"
task :master_base do
  build_vm('./templates/educationbase.json', args={}, var_file='./templates/master.json')
end

desc "Master VM build"
task :master_base do
  build_vm('./templates/educationbuild.json', args={}, var_file='./templates/master.json')
end

desc "Learning VM base build"
task :master_base do
  build_vm('./templates/educationbase.json', args={}, var_file='./templates/learning.json')
end

desc "Learning VM build"
task :master_base do
  build_vm('./templates/educationbuild.json', args={}, var_file='./templates/learning.json')
end

desc "Student VM build"
task :student_build do
  # The student VM doesn't use a var file
  build_vm('./templates/student.json', args={})
end

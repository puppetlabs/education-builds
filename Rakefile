require 'optparse'
require 'open-uri'
require 'progressbar'

def pe_family
  ENV["PE_FAMILY"] or ENV["PE_VERSION"] ? ENV["PE_VERSION"].split('.')[0 .. 1].join('.') : nil
end

def pre_release?
  ENV["PRE_RELEASE"] == 'true'
end

def pe_version
  ENV["PE_VERSION"] || pre_release? ? latest_pre_version(pe_family) : 'latest'
end

def latest_pre_version(pe_family)
  open("http://getpe.delivery.puppetlabs.net/latest/#{pe_family}").read
end

def pre_release_url
  "http://enterprise.delivery.puppetlabs.net/#{pe_family}/ci-ready/puppet-enterprise-#{pe_version}-el-7-x86_64.tar"
end

def pe_installer_url
  if pre_release?
    pre_release_url
  else
    "https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=#{pe_version}"
  end
end

def already_cached?(path)
  File.exist?(path) and File.zero?(path) == false
end

def download(url, path)
  begin
    File.open(path,"wb") do |saved_file|
      saved_file.print open(url, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end
  rescue OpenURI::HTTPError => e
    puts "ERROR: Could not find an installer for the specified version!"
    raise e
  end 
end

desc "Cache vagrant boxes"
task :cache_vagrant_boxes do
end

desc "Set up default cache dirctories"
task :set_up_cache_dirs do
  FileUtils.mkdir_p(["./file_cache/gems", "./file_cache/installers", "./file_cache", "./output", "./packer_cache"])
end

desc "Cache the PE Installer"
task :cache_pe_installer do
  if pre_release?
    abort("ERROR: You must specify a family or version for a pre-release build") unless pe_family or pe_version
  end
  cached_installer_path = "./file_cache/installers/puppet-enterprise-#{pe_version}-el-7-x86_64.tar"
  if not already_cached?(cached_installer_path) 
    puts "Downloading PE installer for #{pe_version}"
    download(pe_installer_url, cached_installer_path)
  else
    puts "PE Installer for #{pe_version} is already cached. Moving on..."
  end
end

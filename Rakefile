require 'erb'
require 'uri'
require 'net/http'
require 'net/https'
require 'rubygems'
require 'nokogiri'

STDOUT.sync = true
BASEDIR = File.dirname(__FILE__)
PEVERSION = ENV['PEVERSION'] || '3.7.0'
PESTATUS = ENV['PESTATUS'] || 'release'
SRCDIR = ENV['SRCDIR'] || '/usr/src'
PUPPET_VER = '3.6.2'
FACTER_VER = '1.7.5'
HIERA_VER = '1.3.4'

$settings = Hash.new

hostos = `uname -s`

# Bail if handed a 'vmtype' that's not supported.
if ENV['vmtype'] && ENV['vmtype'] !~ /^(training|learning|student)$/
  abort("ERROR: Unrecognized vmtype parameter: #{ENV['vmtype']}")
end

desc "Build and populate data directory"
task :init do

  cputs "Cloning puppet..."
  gitclone 'https://github.com/puppetlabs/puppet', "#{SRCDIR}/puppet", 'master', "#{PUPPET_VER}"

  cputs "Cloning facter..."
  gitclone 'https://github.com/puppetlabs/facter', "#{SRCDIR}/facter", 'master', "#{FACTER_VER}"

  cputs "Cloning hiera..."
  gitclone 'https://github.com/puppetlabs/hiera', "#{SRCDIR}/hiera", 'master', "#{HIERA_VER}"


  STDOUT.sync = true
  STDOUT.flush
end

def download(url,path)
  u = URI.parse(url)
  net = Net::HTTP.new(u.host, u.port)
  case u.scheme
  when "http"
    net.use_ssl = false
  when "https"
    net.use_ssl = true
    net.verify_mode = OpenSSL::SSL::VERIFY_NONE
  else
    raise "Link #{url} is not HTTP(S)"
  end
  net.start do |http|
    File.open(path,"wb") do |f|
      begin
        http.request_get(u.path) do |resp|
          resp.read_body do |segment|
            f.write(segment)
          end
        end
      rescue => e
        cputs "Error: #{e.message}"
      end
    end
  end
end

def gitclone(source,destination,branch,tag = nil)
  if File.directory?(destination) then
    system("cd #{destination} && (git pull origin #{branch}") or raise(Error, "Cannot pull ${source}")
  else
    system("git clone #{source} #{destination} -b #{branch}") or raise(Error, "Cannot clone #{source}")
    system("cd #{destination} && git checkout #{tag}") if tag
  end
end

## Prompt for a response if a given ENV variable isn't set.
#
# args:
#   message:  the message you want displayed
#   varname:  the name of the environment variable to look for
#
# usage: update = env_prompt('Increment the release version? [Y/n]: ', 'RELEASE')
def env_prompt(message, varname)
  if ENV.include? varname
    ans = ENV[varname]
  else
    cprint message
    ans = STDIN.gets.strip
  end
  return ans
end

def prompt_del(del=nil)
  del = del || ENV['del']
  loop do
    cprint "Do you want to delete the packaged VMs in #{CACHEDIR}? [no]: "
    del = STDIN.gets.chomp.downcase
    del = 'no' if del.empty?
    puts del
    if del !~ /(y|n|yes|no)/
      cputs "Please answer with yes or no (y/n)."
    else
      break #loop
    end
  end unless del
  if del =~ /(y|yes)/
    $settings[:del] = 'yes'
  else
    $settings[:del] = 'no'
  end
end

def prompt_vmos(osname=nil)
  osname = osname || ENV['vmos']
  loop do
    cprint "Please choose an OS type of 'Centos' or 'Ubuntu' [Centos]: "
    osname = STDIN.gets.chomp
    osname = 'Centos' if osname.empty?
    if osname !~ /(Ubuntu|Centos)/
      cputs "Incorrect/unknown OS: #{osname}"
    else
      break #loop
    end
  end unless osname
  $settings[:vmos] = osname
end

def prompt_vmtype(type=nil)
  type = type || ENV['vmtype']
  loop do
    cprint "Please choose the type of VM - one of 'training' or 'learning' [training]: "
    type = STDIN.gets.chomp
    type = 'training' if type.empty?
    if type !~ /(training|learning)/
      cputs "Incorrect/unknown type of VM: #{type}"
    else
      break #loop
    end
  end unless type
  $settings[:vmtype] = type
end

def build_file(filename)
  template_path = "#{BASEDIR}/files/#{$settings[:vmos]}/#{filename}.erb"
  target_dir = "#{BUILDDIR}/#{$settings[:vmos]}"
  target_path = "#{target_dir}/#{filename}"
  FileUtils.mkdir(target_dir) unless File.directory?(target_dir)
  if File.file?(template_path)
    cputs "Building #{target_path}..."
    File.open(target_path,'w') do |f|
      template_content = ERB.new(File.read(template_path)).result
      f.write(template_content)
    end
  else
    cputs "No source template found: #{template_path}"
  end
end

def map_iso(indev,outdev,paths)
  maps = paths.collect do |frompath,topath|
    "-map '#{frompath}' '#{topath}'"
  end.join(' ')
  system("xorriso -osirrox on -boot_image any patch -indev #{indev} -outdev #{outdev} #{maps}")
end

def verify_download(download, signature)
  crypto = GPGME::Crypto.new
  sign = GPGME::Data.new(File.open(signature))
  file_to_check = GPGME::Data.new(File.open(download))
  crypto.verify(sign, :signed_text => file_to_check, :always_trust => true) do |signature|
   puts "Valid!" if signature.valid?
  end
end

def cputs(string)
  puts "\033[1m#{string}\033[0m"
end

def cprint(string)
  print "\033[1m#{string}\033[0m"
end

# If we want a test version, figure out the latest in the series and download it, otherwise get the release version
def get_pe(pe_install_suffix)
  if PESTATUS =~ /latest/
    perelease=PEVERSION.split('.')
    @real_pe_ver=`curl http://neptune.delivery.puppetlabs.net/#{perelease[0]}.#{perelease[1]}/ci-ready/LATEST`.chomp
  else
    @real_pe_ver=PEVERSION
  end
  cputs "Actual PE version is #{@real_pe_ver}"
  perelease = @real_pe_ver.split('.')
  if PESTATUS =~ /latest/
    url_prefix    = "http://neptune.delivery.puppetlabs.net/#{perelease[0]}.#{perelease[1]}/ci-ready"
    pe_tarball    = "puppet-enterprise-#{@real_pe_ver}#{pe_install_suffix}.tar"
  elsif PESTATUS =~ /release/
    url_prefix    = "https://s3.amazonaws.com/pe-builds/released/#{@real_pe_ver}"
    pe_tarball    = "puppet-enterprise-#{@real_pe_ver}#{pe_install_suffix}.tar.gz"
  else
    abort("Status: #{PESTATUS} not valid - use 'release' or 'latest'.")
  end
  installer       = "#{CACHEDIR}/#{pe_tarball}"
  unless File.exist?(installer)
    cputs "Downloading PE tarball #{@real_pe_ver}..."
    download("#{url_prefix}/#{pe_tarball}", installer)
  end
  if PESTATUS =~ /release/
    unless File.exist?("#{installer}.asc")
      cputs "Downloading PE signature asc file for #{@real_pe_ver}..."
      download "#{url_prefix}/#{pe_tarball}.asc", "#{CACHEDIR}/#{pe_tarball}.asc"
    end

    cputs "Verifying installer signature"
  end
  return pe_tarball
end
# vim: set sw=2 sts=2 et tw=80 :

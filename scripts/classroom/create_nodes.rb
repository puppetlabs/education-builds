#! /usr/bin/env ruby
require 'fileutils'

def run_with_notice(command, message)
  printf("\r#{message}")
  system("#{command} >/dev/null")

  width = `tput cols`.to_i - 12
  printf("\r%-#{width}s[\033[32m  OK  \033[0m]\n", message)
end

# make sure we've got an ssldir to work with
unless File.exists? '/tmp/ssl'
  FileUtils.mkdir '/tmp/ssl'
  FileUtils.mkdir '/tmp/ssl/certs'
  FileUtils.mkdir '/tmp/ssl/private_keys'
end


case ARGV.size
when 0
  script = File.basename __FILE__
  puts <<-END.gsub(/^ {4}/, '')
    Usage: #{script} [ list, of, nodenames, to, create | remove ]

    This script will accept any number of nodenames on the commandline and will
    run Puppet in a temporary ssldir for each nodename. This has the effect of
    generating an arbitrary number of reports in the Console for screenshotting
    purposes. For successful Puppet runs, it will also make a symlink so that
    the Puppet Enterprise module can manage mco certificates.

    * #{script} angelina barry craig wilson batman andrew corrine mandy

    If you call it with the single argument of `remove` then it will crawl through
    the real ssldir and remove all the nasty symlinks we left around.

    * #{script} remove

  END
  exit
when 1
  case ARGV.first
  when 'remove'
    files  = Dir.glob('/etc/puppetlabs/puppet/ssl/certs/*')
    files += Dir.glob('/etc/puppetlabs/puppet/ssl/private_keys/*')

    files.select { |file| File.symlink? file }.each do |file|
      puts "Deleting: #{file}"
      FileUtils.rm file
    end
    exit
  end
end

ARGV.shuffle.each do |arg|
  # for the puppet_enterprise mcollective certs
  unless File.symlink? "/etc/puppetlabs/puppet/ssl/certs/#{arg}.puppetlabs.vm.pem"
    FileUtils.ln_sf "/tmp/ssl/certs/#{arg}.puppetlabs.vm.pem", "/etc/puppetlabs/puppet/ssl/certs/#{arg}.puppetlabs.vm.pem"
    FileUtils.ln_sf "/tmp/ssl/private_keys/#{arg}.puppetlabs.vm.pem", "/etc/puppetlabs/puppet/ssl/private_keys/#{arg}.puppetlabs.vm.pem"
  end

  run_with_notice("puppet agent -t --ssldir /tmp/ssl --certname '#{arg}.puppetlabs.vm'", "Running Puppet on #{arg}...")

  # if the cert has already been signed, then sleep for a random time before moving on
  # this makes report times look slightly more believable
  if File.file? "/tmp/ssl/certs/#{arg}.puppetlabs.vm.pem"
    number = rand(60)
    print "Sleeping for #{number} seconds..."
    STDOUT.flush
    sleep number
  end

end
puts

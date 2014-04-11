#! /bin/sh

if [[ $(hostname) != "master.puppetlabs.vm" && $(hostname) != "classroom.puppetlabs.vm" ]]
then
  echo "This tool is intended to be run on the classroom master."
  echo "Do you wish to continue anyway? [yes/NO]"
  read junk
  [ "${junk}" != "yes" ] && exit 1
fi

echo
echo
echo "################################################################################"
echo
echo "This script will completely reset all certificates on a standalone Puppet Master"
echo
echo "             Press Control-C now to abort or [enter] to continue."
echo
echo "################################################################################"
echo
read junk

mkdir ~/certificates.bak/{puppet,puppetdb,puppet-dashboard}
cp -a /etc/puppetlabs/puppet/ssl ~/certificates.bak/puppet/
cp -a /etc/puppetlabs/puppetdb/ssl ~/certificates.bak/puppetdb/
cp -a /opt/puppet/share/puppet-dashboard/certs ~/certificates.bak/puppet-dashboard/

echo "Certificates backed up to ~/certificates.bak"

service pe-puppet stop
service pe-mcollective stop
service pe-httpd stop
rm -rf /etc/puppetlabs/puppet/ssl/*
puppet cert list -a
echo "Press Ctrl-C once you see 'Starting Puppet master version x.y.z'"
puppet master --no-daemonize --verbose
service pe-httpd start
echo "Puppet Master certificates regenerated"

service pe-puppetdb stop
rm -rf /etc/puppetlabs/puppetdb/ssl/*
/opt/puppet/sbin/puppetdb-ssl-setup -f
service pe-puppetdb start
echo "PuppetDB certificates regenerated"

cd /opt/puppet/share/puppet-dashboard/certs
rm -rf /opt/puppet/share/puppet-dashboard/certs/*
/opt/puppet/bin/rake RAILS_ENV=production cert:create_key_pair
/opt/puppet/bin/rake RAILS_ENV=production cert:request
puppet cert sign pe-internal-dashboard
/opt/puppet/bin/rake RAILS_ENV=production cert:retrieve
chown -R puppet-dashboard:puppet-dashboard /opt/puppet/share/puppet-dashboard/certs
service pe-httpd restart
echo "Puppet Enterprise Console certificates regenerated"

puppet agent -t
service pe-puppet start

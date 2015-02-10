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

TIMESTAMP=$(date '+%s')
CERTNAME=$(puppet master --configprint certname)

mkdir -p ~/certificates.bak/{puppet,puppetdb,puppet-dashboard,console-services,pgsql}
cp -a /etc/puppetlabs/puppet/ssl ~/certificates.bak/puppet/${TIMESTAMP}
cp -a /etc/puppetlabs/puppetdb/ssl ~/certificates.bak/puppetdb/${TIMESTAMP}
cp -a /opt/puppet/share/puppet-dashboard/certs ~/certificates.bak/puppet-dashboard/${TIMESTAMP}
cp -a /opt/puppet/share/console-services/certs ~/certificates.bak/console-services/${TIMESTAMP}
cp -a /opt/puppet/var/lib/pgsql/9.2/data/certs ~/certificates.bak/pgsql/${TIMESTAMP}

echo "Certificates backed up to ~/certificates.bak"

puppet resource service pe-puppet ensure=stopped
puppet resource service pe-puppetserver ensure=stopped
puppet resource service pe-activemq ensure=stopped
puppet resource service pe-mcollective ensure=stopped
puppet resource service pe-puppetdb ensure=stopped
puppet resource service pe-postgresql ensure=stopped
puppet resource service pe-console-services ensure=stopped
puppet resource service pe-httpd ensure=stopped

rm -rf /etc/puppetlabs/puppet/ssl/*
rm -f /var/opt/lib/pe-puppet/client_data/catalog/${CERTNAME}.json

puppet cert list -a
puppet cert --generate ${CERTNAME} --dns_alt_names "$(puppet master --configprint dns_alt_names)" --verbose
puppet cert generate pe-internal-classifier
puppet cert generate pe-internal-dashboard
puppet cert generate pe-internal-mcollective-servers
puppet cert generate pe-internal-peadmin-mcollective-client
puppet cert generate pe-internal-puppet-console-mcollective-client
cp /etc/puppetlabs/puppet/ssl/ca/ca_crl.pem /etc/puppetlabs/puppet/ssl/crl.pem
chown -R pe-puppet:pe-puppet /etc/puppetlabs/puppet/ssl
echo "Puppet Master certificates regenerated"

rm -rf /etc/puppetlabs/puppetdb/ssl/*
cp /etc/puppetlabs/puppet/ssl/certs/${CERTNAME}.pem /etc/puppetlabs/puppetdb/ssl/${CERTNAME}.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/${CERTNAME}.pem /etc/puppetlabs/puppetdb/ssl/${CERTNAME}.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/${CERTNAME}.pem /etc/puppetlabs/puppetdb/ssl/${CERTNAME}.private_key.pem
chown -R pe-puppetdb:pe-puppetdb /etc/puppetlabs/puppetdb/ssl
echo "PuppetDB certificates regenerated"

rm -rf /opt/puppet/var/lib/pgsql/9.2/data/certs/*
cp /etc/puppetlabs/puppet/ssl/certs/${CERTNAME}.pem /opt/puppet/var/lib/pgsql/9.2/data/certs/${CERTNAME}.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/${CERTNAME}.pem /opt/puppet/var/lib/pgsql/9.2/data/certs/${CERTNAME}.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/${CERTNAME}.pem /opt/puppet/var/lib/pgsql/9.2/data/certs/${CERTNAME}.private_key.pem
chmod 400 /opt/puppet/var/lib/pgsql/9.2/data/certs/*
chown pe-postgres:pe-postgres /opt/puppet/var/lib/pgsql/9.2/data/certs/*
echo "PostgreSQL certificates regenerated"

rm -rf /opt/puppet/share/console-services/certs/*
cp /etc/puppetlabs/puppet/ssl/certs/pe-internal-classifier.pem /opt/puppet/share/console-services/certs/pe-internal-classifier.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/pe-internal-classifier.pem /opt/puppet/share/console-services/certs/pe-internal-classifier.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-classifier.pem /opt/puppet/share/console-services/certs/pe-internal-classifier.private_key.pem
cp /etc/puppetlabs/puppet/ssl/certs/${CERTNAME}.pem /opt/puppet/share/console-services/certs/${CERTNAME}.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/${CERTNAME}.pem /opt/puppet/share/console-services/certs/${CERTNAME}.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/${CERTNAME}.pem /opt/puppet/share/console-services/certs/${CERTNAME}.private_key.pem
cp /etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem /opt/puppet/share/console-services/certs/pe-internal-dashboard.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/pe-internal-dashboard.pem /opt/puppet/share/console-services/certs/pe-internal-dashboard.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem /opt/puppet/share/console-services/certs/pe-internal-dashboard.private_key.pem
chown -R pe-console-services:pe-console-services /opt/puppet/share/console-services/certs
echo "Puppet Enterprise Console Services certificates regenerated"

rm -rf /opt/puppet/share/puppet-dashboard/certs/*
cp /etc/puppetlabs/puppet/ssl/certs/${CERTNAME}.pem /opt/puppet/share/puppet-dashboard/certs/${CERTNAME}.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/${CERTNAME}.pem /opt/puppet/share/puppet-dashboard/certs/${CERTNAME}.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/${CERTNAME}.pem /opt/puppet/share/puppet-dashboard/certs/${CERTNAME}.private_key.pem
cp /etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/pe-internal-dashboard.pem /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem
chown -R puppet-dashboard:puppet-dashboard /opt/puppet/share/puppet-dashboard/certs
echo "Puppet Enterprise Console certificates regenerated"

puppet resource service pe-puppetserver ensure=running
puppet resource service pe-postgresql ensure=running
puppet resource service pe-puppetdb ensure=running
puppet resource service pe-console-services ensure=running
puppet resource service pe-httpd ensure=running
puppet resource service pe-activemq ensure=running
puppet resource service pe-mcollective ensure=running

puppet agent -t
puppet resource service pe-puppet ensure=running

echo "All certificates regenerated. Please regenerate certificates on all agents now."

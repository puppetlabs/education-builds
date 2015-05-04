#LMS VM cleanup scripts
PATH=/opt/puppet/bin:$PATH
puppet config set certname ${HOSTNAME}
puppet config set server ${HOSTNAME}
puppet cert --generate ${HOSTNAME} --dns_alt_names "puppet,${HOSTNAME}" --verbose


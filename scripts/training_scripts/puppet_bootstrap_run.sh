source ./setup_environment.sh
# Clone the bootstrap repository and run Puppet
#   TRAINING_REPO:    URI to the bootstrap repo
#   TRAINING_BRANCH:  Specific branch to clone
#   RUBY_LIB:         What will be set as $RUBYLIB
echo "Executing:  git clone ${TRAINING_REPO} -b ${TRAINING_BRANCH} /usr/src/puppetlabs-training-bootstrap"
git clone "${TRAINING_REPO}" -b "${TRAINING_BRANCH}" /usr/src/puppetlabs-training-bootstrap

/usr/bin/ruby /usr/src/puppetlabs-training-bootstrap/scripts/version.rb >> /etc/puppetlabs-release
echo "/usr/src/puppet/bin/puppet apply --modulepath=/usr/src/puppetlabs-training-bootstrap/modules --verbose /usr/src/puppetlabs-training-bootstrap/manifests/site.pp"
/usr/src/puppet/bin/puppet apply --modulepath=/usr/src/puppetlabs-training-bootstrap/modules --verbose /usr/src/puppetlabs-training-bootstrap/manifests/site.pp


cp /usr/src/puppetlabs-training-bootstrap/files/registerdns.sh /etc/rc3.d/S16registerdns.sh

# Exiting 0 so a Puppet run's exit code doesn't sink the ship
exit 0

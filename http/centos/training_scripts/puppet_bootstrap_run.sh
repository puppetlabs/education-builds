# Clone the bootstrap repository and run Puppet
#   TRAINING_REPO:    URI to the bootstrap repo
#   TRAINING_BRANCH:  Specific branch to clone
#   RUBY_LIB:         What will be set as $RUBYLIB
echo "Executing:  git clone ${TRAINING_REPO} -b ${TRAINING_BRANCH} /usr/src/puppetlabs-training-bootstrap"
git clone "${TRAINING_REPO}" -b "${TRAINING_BRANCH}" /usr/src/puppetlabs-training-bootstrap

# So, I tried to set RUBYLIB in Packer, but it kept getting swallowed for some
# reason (and I didn't have time to track it down). The solution was to use ANY
# OTHER variable OTHER than 'RUBYLIB' and then export it inside the script.
# It's kind of ugly, but whatever.
export RUBYLIB=$RUBY_LIB
echo "/usr/src/puppet/bin/puppet apply --modulepath=/usr/src/puppetlabs-training-bootstrap/modules --verbose /usr/src/puppetlabs-training-bootstrap/manifests/site.pp"
/usr/src/puppet/bin/puppet apply --modulepath=/usr/src/puppetlabs-training-bootstrap/modules --verbose /usr/src/puppetlabs-training-bootstrap/manifests/site.pp

# Exiting 0 so a Puppet run's exit code doesn't sink the ship
exit 0

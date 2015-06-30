if $::hostname == "lms" {
  # Put LMS files in place
  include lms::lab_repo
  include lms::course_selector
}
# Disable non-local yum repos
yumrepo { [ 'updates', 'base', 'extras', 'epel']:
  enabled  => '0',
  priority => '99',
  skip_if_unavailable => '1',
}

# Delete cruft left by install process
file { [
  '/root/install.log',
  '/root/install.log.syslog',
  '/root/linux.iso',
  '/root/post.log',
  '/root/anaconda-ks.cfg'
]:
  ensure => absent,
}

# This is a temporary hack to make sure that student masters have a
# production environment created. We will revisit this post PE3.7 release
#
class classroom::master::student_environment inherits classroom::params {
  $environmentpath = '/etc/puppetlabs/puppet/environments'
  $environmentname = 'production'
  $environment     = "${environmentpath}/${environmentname}"

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  # we need this check because the $environmentpath doesn't exist until the
  # node is classified as a PE Master, so we can't put files into it.
  if defined(Class['puppet_enterprise::profile::master']) {
    file { [
      $environment,
      "${environment}/manifests",
      "${environment}/modules",
    ]:
      ensure => directory,
    }

    file { "${environment}/manifests/site.pp":
      ensure  => file,
      source  => 'puppet:///modules/classroom/site.pp',
      replace => false,
    }

    # Ensure the environment cache is disabled and restart if needed
    ini_setting {'environment_timeout':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'main',
      setting => 'environment_timeout',
      value   => '0',
    }

    # Ensure the environmentpath is configured and restart if needed
    ini_setting {'environmentpath':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'main',
      setting => 'environmentpath',
      value   => $environmentpath,
    }
  }
}

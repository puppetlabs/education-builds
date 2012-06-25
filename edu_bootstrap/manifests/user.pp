define edu_bootstrap::user(
  # Password defaults to puppetlabs
  $password='$1$Av8OZEC1$bTdzLXqDgQcH7rDG9DO/Z/'
) {

  include edu_env
  include concat::setup
  include netatalk

  user { $name:
    ensure   => present,
    gid      => 'pe-puppet',
    password => 'puppetlabs',
    home     => "/home/${name}",
  }

  file { ["/home/${name}", "/home/${name}/modules"]:
    ensure => directory,
    owner  => $name,
    group  => 'pe-puppet',
    mode   => '0770',
  }

  concat::fragment{ "${name}_env":
    target  => '/etc/puppetlabs/puppet/puppet.conf',
    content => "[${name}]\n  modulepath=/home/${name}/modules\n",
    order   => '02',
    require => Concat::Fragment['puppet_conf'],
  }

}

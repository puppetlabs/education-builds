define edu_bootstrap::user(
  # Password defaults to puppetlabs
  $password='$1$Tge1IxzI$kyx2gPUvWmXwrCQrac8/m0'
) {

  include edu_bootstrap
  include concat::setup
<<<<<<< HEAD
  include edu_bootstrap::repo
=======
>>>>>>> 60cdac3283cc1099866cb0badd3afd74755298de

  user { $name:
    ensure   => present,
    gid      => 'pe-puppet',
    password => $password,
    home     => "/home/${name}",
  }

  file { ["/home/${name}", "/home/${name}/modules"]:
    ensure => directory,
    owner  => $name,
    group  => 'pe-puppet',
    mode   => '0770',
  }

  file { "/home/${name}/site.pp":
    ensure => file,
    owner  => $name,
    group  => 'pe-puppet',
  }

  concat::fragment{ "${name}_env":
    target  => '/etc/puppetlabs/puppet/puppet.conf',
    content => "[${name}]\n  modulepath=/home/${name}/modules:/opt/puppet/share/puppet/modules\n  manifest=/home/${name}/site.pp\n",
    order   => '02',
    require => Concat::Fragment['puppet_conf'],
  }

  exec { "add_console_user_${name}":
    path    => '/opt/puppet/bin:/usr/bin',
    cwd     => '/opt/puppet/share/console-auth',
    command => "rake db:create_initial_admin[${name}@puppetlabs.com,puppetlabs]",
    unless  => "test -d /home/${name}",
    before  => File["/home/${name}"],
  }

}

class vagrant {

  file { '/etc/sudoers.d/vagrant':
    ensure   => file,
    mode     => '0440',
    owner    => 'root',
    content  => "vagrant ALL=(ALL) ALL\nDefaults  !requiretty\n",
    require  => User['vagrant'],
  }

  # Vagrant public key
  # https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub

 $pub_key = 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ=='

  user { 'vagrant':
    ensure     => present,
    home       => '/var/vagrant',
    managehome => true,
  }

  ssh_authorized_key { 'vagrant public key':
    ensure => present,
    key    => $pub_key,
    name   => 'vagrant insecure public key',
    user   => 'vagrant',
    type   => 'ssh-rsa',
  }
}

class bootstrap::cache_gems (
  $cache_dir = '/var/cache'
) {
  Bootstrap::Gem {
    cache_dir => "${cache_dir}/gems",
  }

  file { [ $cache_dir, "${cache_dir}/gems" ]:
    ensure => directory,
  }

  package { 'builder':
    ensure   => present,
    provider => 'gem',
    require  => Package['rubygems'],
  }

  exec { 'rebuild_gem_cache':
    command     => "gem generate_index -d ${cache_dir}",
    path        => '/opt/puppet/bin:/usr/local/bin:/usr/bin:/bin',
    refreshonly => true,
  }

  file { '/root/.gemrc':
    ensure => file,
    source => 'puppet:///modules/bootstrap/gemrc',
  }

  bootstrap::gem { 'addressable':                    version => '2.3.6'  }
  bootstrap::gem { 'carrier-pigeon':                 version => '0.7.0'  }
  bootstrap::gem { 'rack-protection':                version => '1.4'    }
  bootstrap::gem { 'rack':                           version => '1.4'    }
  bootstrap::gem { 'sinatra':                        version => '1.4.5'  }
  bootstrap::gem { 'tilt':                           version => '1.3.4'  }
  bootstrap::gem { 'formatr':                        version => '1.10.1' }
  bootstrap::gem { 'net-ssh':                        version => '2.9.1'  }
  bootstrap::gem { 'highline':                       version => '1.6.21' }
  bootstrap::gem { 'serverspec':                     version => '1.16.0' }
  bootstrap::gem { 'trollop':                        version => '2.0'    }
  bootstrap::gem { 'hiera-eyaml':                    version => '2.0.3'  }
  bootstrap::gem { 'diff-lcs':                       version => '1.2.5'  }
  bootstrap::gem { 'rspec-puppet':                   version => '1.0.1'  }
  bootstrap::gem { 'mocha':                          version => '1.1.0'  }
  bootstrap::gem { 'metaclass':                      version => '0.0.1'  }
  bootstrap::gem { 'puppetlabs_spec_helper':         version => '0.8.2'  }
  bootstrap::gem { 'puppet-lint':                    version => '1.1.0'  }
  bootstrap::gem { 'rspec':                          version => '2.99.0' }
  bootstrap::gem { 'rspec-its':                      version => '1.0.1'  }
  bootstrap::gem { 'rspec-core':                     version => '2.99.0' }
  bootstrap::gem { 'rspec-mocks':                    version => '2.99.0' }
  bootstrap::gem { 'rspec-expectations':             version => '2.99.0' }
  bootstrap::gem { 'specinfra':                      version => '1.27'   }
  bootstrap::gem { 'r10k':                           version => '1.3.4'  }
  bootstrap::gem { 'colored':                        version => '1.2'    }
  bootstrap::gem { 'cri':                            version => '2.5.0'  }
  bootstrap::gem { 'faraday':                        version => '0.8.8'  }
  bootstrap::gem { 'multipart-post':                 version => '2.0.0'  }
  bootstrap::gem { 'faraday_middleware':             version => '0.9.0'  }
  bootstrap::gem { 'faraday_middleware-multi_json':  version => '0.0.5'  }
  bootstrap::gem { 'json_pure':                      version => '1.8.1'  }
  bootstrap::gem { 'log4r':                          version => '1.1.10' }
  bootstrap::gem { 'multi_json':                     version => '1.8.2'  }
  bootstrap::gem { 'systemu':                        version => '2.5.2'  }
  bootstrap::gem { 'rake':                           version => '10.3.2' }
  bootstrap::gem { 'puppet-syntax':                  version => '1.3.0'  }
  bootstrap::gem { 'hocon':                          version => '0.0.6'  }


  Bootstrap::Gem <| |> -> File['/root/.gemrc']

}

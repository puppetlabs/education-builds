class bootstrap::cache_gems (
  $cache_dir = '/var/cache/rubygems'
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

  bootstrap::gem { 'addressable':                            }
  bootstrap::gem { 'carrier-pigeon':                         }
  bootstrap::gem { 'rack-protection':                        }
  bootstrap::gem { 'sinatra':                                }
  bootstrap::gem { 'tilt':                                   }
  bootstrap::gem { 'formatr':                                }
  bootstrap::gem { 'net-ssh':                                }
  bootstrap::gem { 'highline':                               }
  bootstrap::gem { 'serverspec':         version => '1.16.0' }
  bootstrap::gem { 'trollop':                                }
  bootstrap::gem { 'hiera-eyaml':                            }
  bootstrap::gem { 'diff-lcs':                               }
  bootstrap::gem { 'rspec-puppet':                           }
  bootstrap::gem { 'mocha':                                  }
  bootstrap::gem { 'metaclass':                              }
  bootstrap::gem { 'puppetlabs_spec_helper':                 }
  bootstrap::gem { 'puppet-lint':                            }
  bootstrap::gem { 'rspec':              version => '2.99.0' }
  bootstrap::gem { 'rspec-its':          version => '1.0.1'  }
  bootstrap::gem { 'rspec-core':         version => '2.99.0' }
  bootstrap::gem { 'rspec-mocks':        version => '2.99.0' }
  bootstrap::gem { 'rspec-expectations': version => '2.99.0' }
  bootstrap::gem { 'specinfra':          version => '1.27'   }

  Bootstrap::Gem <| |> -> File['/root/.gemrc']

}

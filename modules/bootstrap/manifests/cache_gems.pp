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

  bootstrap::gem { 'addressable':                                        }
  bootstrap::gem { 'carrier-pigeon':                                     }
  bootstrap::gem { 'rack-protection':                                    }
  bootstrap::gem { 'sinatra':                                            }
  bootstrap::gem { 'tilt':                                               }
  bootstrap::gem { 'formatr':                                            }
  bootstrap::gem { 'net-ssh':                                            }
  bootstrap::gem { 'highline':                                           }
  bootstrap::gem { 'serverspec':                     version => '1.16.0' }
  bootstrap::gem { 'trollop':                                            }
  bootstrap::gem { 'hiera-eyaml':                                        }
  bootstrap::gem { 'diff-lcs':                                           }
  bootstrap::gem { 'rspec-puppet':                                       }
  bootstrap::gem { 'mocha':                                              }
  bootstrap::gem { 'metaclass':                                          }
  bootstrap::gem { 'puppetlabs_spec_helper':                             }
  bootstrap::gem { 'puppet-lint':                                        }
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


  Bootstrap::Gem <| |> -> File['/root/.gemrc']

}

class bootstrap::cache_gems (
  $cache_dir = '/var/cache/gems'
) {
  Bootstrap::Gem {
    cache_dir => $cache_dir,
  }

  file { $cache_dir:
    ensure => directory,
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

  # These are the gems needed by the Fundamentals course


  # These are the gems needed by the Advanced course
  bootstrap::gem { 'addressable':     }
  bootstrap::gem { 'carrier-pigeon':  }
  bootstrap::gem { 'rack-protection': }
  bootstrap::gem { 'sinatra':         }
  bootstrap::gem { 'tilt':            }
  bootstrap::gem { 'net-ssh':         }
  bootstrap::gem { 'highline':        }
  bootstrap::gem { 'serverspec':      }

  # These are the gems needed by the extending puppet using ruby course
  bootstrap::gem { 'rspec':                  }
  bootstrap::gem { 'diff-lcs':               }
  bootstrap::gem { 'rspec-core':             }
  bootstrap::gem { 'rspec-mocks':            }
  bootstrap::gem { 'rspec-puppet':           }
  bootstrap::gem { 'rspec-expectations':     }
  bootstrap::gem { 'mocha':                  }
  bootstrap::gem { 'metaclass':              }
  bootstrap::gem { 'puppetlabs_spec_helper': }

}

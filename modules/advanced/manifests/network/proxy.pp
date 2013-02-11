# Example proxy configuration, not related to haproxy
class advanced::network::proxy.pp {
    file_line { 'yum.conf':
      path => '/etc/yum.conf',
      line => 'proxy=http://proxy-us.puppetlabs.com:911',
    }
    #file { '/etc/yum.repos.d/dvd.repo':
    #  ensure =>absent,
    #}
}

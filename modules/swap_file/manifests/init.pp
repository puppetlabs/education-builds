# Class: swap_file
#
# This class manages swapspace on a node.
#
# == Parameters
# [*ensure*]
#   Allows creation or removal of swapspace and the corresponding file.
# [*swapfile*]
#   Location of swapfile, defaults to /mnt
# [*swapfilesize*]
#   Size of the swapfile as a string (eg. 10 MB, 1.2 GB).
#   Defaults to $::memorysize fact on the node
#
# == Examples
#
#   include swap_file
#
#   class { 'swap_file':
#     ensure => present,
#   }
#
#   class { 'swap_file':
#     swapfile => '/mount/swapfile',
#     swapfilesize => '100 MB',
#   }
#
# == Authors
#    @petems - Peter Souter
#    @Yggdrasil
#
class swap_file (
  $ensure        = 'present',
  $swapfile      = '/mnt/swap.1',
  $swapfilesize  = $::memorysize,
  $add_mount     = true
) inherits swap_file::params {

  # Parameter validation
  validate_re($ensure, ['^absent$', '^present$'], "Invalid ensure: ${ensure} - (Must be 'present' or 'absent')")
  validate_string($swapfile)
  $swapfilesize_mb = to_bytes($swapfilesize) / 1000000
  validate_bool($add_mount)

  if $ensure == 'present' {
      exec { 'Create swap file':
        command => "/bin/dd if=/dev/zero of=${swapfile} bs=1M count=${swapfilesize_mb}",
        creates => $swapfile,
      }
      exec { 'Attach swap file':
        command => "/sbin/mkswap ${swapfile} && /sbin/swapon ${swapfile}",
        require => Exec['Create swap file'],
        unless  => "/sbin/swapon -s | grep ${swapfile}",
      }
      if $add_mount {
        mount { 'swap':
          ensure  => present,
          fstype  => swap,
          device  => $swapfile,
          dump    => 0,
          pass    => 0,
          require => Exec['Attach swap file'],
        }
      }
    }
  elsif $ensure == 'absent' {
    exec { 'Detach swap file':
      command => "/sbin/swapoff ${swapfile}",
      onlyif  => "/sbin/swapon -s | grep ${swapfile}",
    }
    file { $swapfile:
      ensure  => absent,
      backup  => false,
      require => Exec['Detach swap file'],
    }
    mount { 'swap':
      ensure  => absent,
      device  => $swapfile,
      require => File[$swapfile],
    }
  }
}

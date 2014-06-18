# Create a few scripts useful for working with reports. These are
# primarily used for the Practitioner course at this point.
class classroom::master::reporting_tools {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0777',
  }

  file { '/usr/local/bin/get_environment_version.sh':
    ensure => file,
    source => 'puppet:///modules/classroom/get_environment_version.sh',
  }

  file { '/usr/local/bin/process_reports.rb':
    ensure => file,
    source => 'puppet:///modules/classroom/process_reports.rb',
  }
}

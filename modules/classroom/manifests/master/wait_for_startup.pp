# The new PE stack takes a very long time to startup, which can cause
# disconcerting errors. This simply schedules that to the end of the run
# and waits for the service to resume servicing requests before allowing
# the run to complete. This ensures that if services are restarted, that
# will happen *after* any resources that depend on them to be running
# are enforced and that the service is available to receive the report.
#
# Affected resources:
#   resources that use Console APIs
#   file resources that may call back for `puppet:///` URIs
#
# please don't hate me for this horrible hack.
#
class classroom::master::wait_for_startup {

  File <| |>                           -> Service['pe-puppetserver']
  Classroom::Console::User <| |>       -> Service['pe-console-services']
  Classroom::Console::Groupparam <| |> -> Service['pe-console-services']

  exec { 'wait for PE stack to startup':
    path        => '/opt/puppet/bin:/bin:/usr/bin',
    command     => "while true; do puppet status ${clientcert} --terminus rest && break; sleep 5; done",
    subscribe   => Service['pe-puppetserver', 'pe-console-services', 'pe-puppetdb'],
    refreshonly => true,
    provider    => 'shell',
  }
}

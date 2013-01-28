define prosody::user ( $ensure = present, $password = undef ) {
  $jid      = "${name}@${::fqdn}"
  $accounts = regsubst("/var/lib/prosody/${::fqdn}/accounts", '\.', '%2e', 'G')
  $dat      = "${accounts}/${name}.dat"

  Exec {
    path => '/bin:/usr/bin',
  }

  case $ensure {
    present: {
      if ! $password { fail("A password for Prosody user ${name} is required.") }

      exec { "Add Prosody user ${name}":
        command => "echo -e '${password}\n${password}' | prosodyctl adduser ${jid}",
        creates => $dat,
      }
    }
    absent: {
      exec { "prosodyctl deluser ${jid}":
        onlyif => "test -e $dat",
      }
    }
    default: {
      notice("Invalid status: ${ensure}")
    }
  }
}


class classroom::agent::geotrust (
  $timeout = $classroom::params::timeout,
) inherits classroom::params {

  if $::osfamily == 'windows' {
    exec { 'download-geotrust-cert':
      command  => 'Invoke-Webrequest https://www.geotrust.com/resources/root_certificates/certificates/GeoTrust_Global_CA.pem -outfile c:\windows\temp\GeoTrust_Glocal_CA.pem',
      creates  => 'c:/windows/temp/GeoTrust_Glocal_CA.pem',
      provider => powershell,
    }
    exec { 'install-geotrust-cert':
      command  => 'certutil -addstore root c:\windows\temp\GeoTrust_Glocal_CA.pem',
      provider => powershell,
      refreshonly => true,
      subscribe  => Exec['download-geotrust-cert'],
    }
  }
  else {
    fail("Geotrust certificate class supports only Windows, not ${::osfamily}")
  }

}

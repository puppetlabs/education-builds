class userprefs::npp {
  file { 'c:\nppinstaller.msi':
    ensure             => file,
    source             => 'puppet:///modules/userprefs/npp/npp.6.6.6.installer.msi',
    source_permissions => ignore,
  }

  package { 'Notepad++ 6.6.6':
    ensure          => present,
    source          => 'c:\nppinstaller.msi',
    install_options => [ '/quiet' ],
    require         => File['c:\nppinstaller.msi'],
  }
}

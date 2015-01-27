class userprefs::npp (
  $user    = 'Administrator',
  $default = true,
)  {
  require classroom::agent::chocolatey

  package { 'notepadplusplus':
    ensure   => present,
    provider => chocolatey,
  }

  file { "C:/Users/${user}/AppData/Roaming/Notepad++":
    ensure  => directory,
    require => Package['notepadplusplus'],
  }

  file { "C:/Users/${user}/AppData/Roaming/Notepad++/userDefineLang.xml":
    ensure  => file,
    replace => false,
    source  => 'puppet:///modules/userprefs/npp/userDefineLang.xml',
    require => Package['notepadplusplus'],
  }

  if $default {
    registry::value { 'Filetype description':
      key    => 'HKLM\Software\Classes\sourcecode',
      value  => '(Default)',
      data   => 'Source Code',
    }

    registry::value { 'open with notepadplusplus':
      key    => 'HKLM\Software\Classes\sourcecode\shell\open\command',
      value  => '(Default)',
      data   => '"C:\Program Files (x86)\Notepad++\notepad++.exe" "%1"',
    }

    registry::value { 'Puppet Manifests':
      key    => 'HKLM\Software\Classes\.pp',
      value  => '(Default)',
      data   => 'sourcecode',
    }

    registry::value { 'YAML files':
      key    => 'HKLM\Software\Classes\.yaml',
      value  => '(Default)',
      data   => 'sourcecode',
    }

    registry::value { 'ERB Templates':
      key    => 'HKLM\Software\Classes\.erb',
      value  => '(Default)',
      data   => 'sourcecode',
    }

    registry::value { 'Ruby Source Code':
      key    => 'HKLM\Software\Classes\.rp',
      value  => '(Default)',
      data   => 'sourcecode',
    }
  }
}

# Parameterized class to configure a user's environment.
#
# Parameters:
#   editor: Installs syntax highlighting and sets $EDITOR
#           Accepts vim/emacs/nano
#    shell: Sets the default shell and installs rc files
#           Accepts zsh/bash
#
class userprefs::user (
  $user   = $::id,
  $editor = undef,
  $shell  = undef,
) {
  # this weird conditional is to support non-root users in Intro
  if $user == 'root' {
    $group   = 'root'
    $homedir = '/root'
  }
  else {
    $group   = 'pe-puppet'
    $homedir = "/home/${user}"
  }

  if $editor {
    if $editor in ['vim', 'emacs', 'nano'] {
      class { "userprefs::${editor}":
        user    => $user,
        group   => $group,
        homedir => $homedir,
      }
    }
    else {
      fail("The editor ${editor} is unsupported")
    }
  }

  if $shell {
    if $shell in ['bash', 'zsh'] {
      class { "userprefs::${shell}":
        user    => $user,
        group   => $group,
        homedir => $homedir,
      }
    }
    else {
      fail("The shell ${shell} is unsupported")
    }
  }

  class { 'userprefs::profile':
    user    => $user,
    group   => $group,
    homedir => $homedir,
  }
}

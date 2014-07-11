# Parameterized class to configure a user's environment.
#
# Parameters:
#   editor: Installs syntax highlighting and sets $EDITOR
#           Accepts vim/emacs/nano
#    shell: Sets the default shell and installs rc files
#           Accepts zsh/bash
#
class userprefs::user (
  $user   = 'root',
  $editor = undef,
  $shell  = undef,
) {
  $homedir = $user ? {
    'root'  => 'root',
    default => "/home/${user}",
  }

  if $editor {
    if $editor in ['vim', 'emacs', 'nano'] {
      class { "userprefs::${editor}":
        user    => $user,
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
        homedir => $homedir,
      }
    }
    else {
      fail("The shell ${shell} is unsupported")
    }
  }

  class { 'userprefs::profile':
    homedir => $homedir,
  }
}

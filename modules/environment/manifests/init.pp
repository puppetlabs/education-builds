# Parameterized class to configure a user's environment.
#
# Parameters:
#   editor: Installs syntax highlighting and sets $EDITOR
#           Accepts vim/emacs/nano
#    shell: Sets the default shell and installs rc files
#           Accepts zsh/bash
#
class environment (
  $editor = undef,
  $shell  = undef,
) {

  if $editor {
    if $editor in ['vim', 'emacs', 'nano'] {
      include "environment::${editor}"
    }
    else {
      fail("The editor ${editor} is unsupported")
    }
  }

  if $shell {
    if $shell in ['bash', 'zsh'] {
      include "environment::${shell}"
    }
    else {
      fail("The shell ${shell} is unsupported")
    }
  }

  # Shell aliases that are used by all shells
  file { '/root/.profile':
    ensure  => 'file',
    replace => false, # allow users to customize their .profile
    source  => 'puppet:///modules/environment/shell/profile',
  }
}

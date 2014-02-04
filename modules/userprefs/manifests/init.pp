# Parameterized class to configure a user's environment.
#
# Parameters:
#   editor: Installs syntax highlighting and sets $EDITOR
#           Accepts vim/emacs/nano
#    shell: Sets the default shell and installs rc files
#           Accepts zsh/bash
#
class userprefs (
  $editor = undef,
  $shell  = undef,
) {

  if $editor {
    if $editor in ['vim', 'emacs', 'nano'] {
      include "userprefs::${editor}"
    }
    else {
      fail("The editor ${editor} is unsupported")
    }
  }

  if $shell {
    if $shell in ['bash', 'zsh'] {
      include "userprefs::${shell}"
    }
    else {
      fail("The shell ${shell} is unsupported")
    }
  }

  include userprefs::profile
}

# Parameterized class to configure a user's environment.
#
# Parameters:
#   editor: Installs syntax highlighting and sets $EDITOR
#           Accepts vim/emacs/nano
#    shell: Sets the default shell and installs rc files
#           Accepts zsh/bash
#
class fundamentals::environment (
  $editor = undef,
  $shell  = undef,
) {

  if $editor in [ 'vim', 'emacs', 'nano' ] {
    include "fundamentals::environment::${editor}"
  }
  elsif $editor != undef {
    notify { "The editor ${editor} is unsupported": }
  }

  if $shell in [ 'zsh', 'bash' ] {
    include "fundamentals::environment::${shell}"
  }
  elsif $shell != undef {
    notify { "The shell ${shell} is unsupported": }
  }

}

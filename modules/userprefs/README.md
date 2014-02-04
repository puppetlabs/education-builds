# userprefs 

## This simply allows users to customize their environment by choosing their editor & shell.

A simple module that allows users to choose their default editor and default shell.

This will ensure that the proper packages are installed, the configuration files that
enable syntax highlighting are written, helpful shell aliases are enabled, and the
default editor and shell are set.

Example usage:

```puppet

    class { 'userprefs':
      shell  => 'zsh',  # allowed values: bash/zsh
      editor => 'vim',  # allowed valued: emacs/nano/vim
    }

```

License
-------


Contact
-------
ben.ford@puppetlabs.com
eduteam@puppetlabs.com

Support
-------

Please log tickets and issues at our [Projects site](http://projects.puppetlabs.com/projects/training/issues)

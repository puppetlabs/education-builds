# userprefs

A simple module that allows users to choose their default editor and default shell.

## About

This will ensure that the proper packages are installed, the configuration files that
enable syntax highlighting are written, helpful shell aliases are enabled, and the
default editor and shell are set.

## Example usage:

Customizing the environment:

```puppet

    class { 'userprefs':
      shell  => 'zsh',  # allowed values: bash/zsh
      editor => 'vim',  # allowed valued: emacs/nano/vim
    }

```

Classifying a node with classroom defaults:

```puppet

    include userprefs::defaults

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

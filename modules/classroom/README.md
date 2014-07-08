# classroom

This module is used to configure the classroom environment for all Puppet Labs
training courses. Unless you are an instructor, this is probably not the module
you are looking for. It makes certain assumptions about the environment and is
only flexible within the design specs of our training courses.

That being said, you're welcome to poke through it and see how we set things up.

## Setting up the training classroom environment.

Simply classify every node in the classroom with `classroom::course::${name}`.

It will manage all roles of all nodes in the classroom as appropriate for
the course you are teaching. Please refer to the InstructorGuide.md for the
appropriate class for more complete instructions.

Contact
-------

education@puppetlabs.com

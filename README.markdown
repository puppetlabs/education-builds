# Bootstrap CentOS VMs for training
Installs the training, student, or learning envirnments on and existing VM.

## Usage
To turn the current machine or VM into one of the Education environments.
NOTE: This changes the hostname and should probably only be done from within a Centos 6.5 32bit base VM.  The old Rakefile will soon be deprecated.

e.g. for a training VM for classroom use:
- `rake -f Rakefile.new training`

## Vagrant
There is a Vagrantfile that builds on the puppetlabs/centos-6.5-32-nocm base box.
There are three boxes specified.

To start a student vagrant box:
- `vagrant up`

To start a training vagrant box for instructor use:
- `vagrant up training`

To start a learning vagrant box:
- `vagrant up learning`

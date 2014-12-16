# Bootstrap CentOS VMs for training
Installs the training, student, or learning envirnments on and existing VM.

## Usage
To turn the current machine or VM into one of the Education environments.
NOTE: This changes the hostname and should probably only be done from within a Centos 6.5 32bit base VM.  The old Rakefile will soon be deprecated.

The basic process is to start a new VM, check out this repo, and run `rake -f Rakefile.new VMNAME` from the root of the repo.

e.g. for a training VM for classroom use:
- Build a new VM and ssh to it
- `git clone https://github.com/puppetlabs/puppetlabs-training-bootstrap bootstrap`
- `cd bootstrap`
- `rake -f Rakefile.new training`

## Vagrant
There is a Vagrantfile that automates this process and builds on the puppetlabs/centos-6.5-32-nocm base box.
There are three boxes specified.

To start a student vagrant box:
- `vagrant up`

To start a training vagrant box for instructor use:
- `vagrant up training`

To start a learning vagrant box:
- `vagrant up learning`

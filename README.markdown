# Bootstrap CentOS VMs for training
Packer build scripts for master, training, student, or learning VMs. See versioned release notes at [ReleaseNotes.md](ReleaseNotes.md).

## Usage
Packer scripts are provided in the `templates` directory. These depend on packer, vmware fusion, and ovftool. The packer builds pull directly from github and the master branch, so changes will need to be checked in.

The base VMs are the published puppetlabs vagrant boxes.  To download and prepare them, run `setup.sh`. This will create the output, file_cache, and packer_cache directories if they don't exist.  If you'd like to keep those on a separate volume to save disk space, create symlinks before running the setup script.

The common configuration options for the training, learning, and master vms have been set up in educationbase.json and vm specific variables are set in VMNAME.json
After the base VM is provisioned according to the settings in VMNAME.json, the bootstrap can be applied using educationbuild.json.

First create a base VM without any bootstrap applied:
- `packer build -var-file=templates/learning.json templates/educationbase.json`

To initiate a packer build of the student vm on the base vm:
- `packer build -var-file=templates/learning.json templates/educationbuild.json`

For the training vm follow the same two steps but with training.json:
- `packer build -var-file=templates/training.json templates/educationbase.json`
- `packer build -var-file=templates/training.json templates/educationbuild.json`

The Student VM is the only VM running Centos6 so it's build template is all in student.json:
- `packer build templates/student.json`

## Vagrant
There is a Vagrantfile that automates this process and builds on the puppetlabs/centos-7.2-x86_64-nocm base box and the puppetlabs/cento-6.6-32-nocm base box for the student VM. The Vagrant boxes will use the current local files.
There are three boxes specified.

To start a student vagrant box:
- `vagrant up`

To start a training vagrant box for instructor use:
- `vagrant up training`

To start a learning vagrant box:
- `vagrant up learning`

## Updating PE version
The version of PE used to build the VM is determined by the pltraining-bootstrap module.
To update the version, set the value of `$pe_version` in `bootstrap::params`.

## Internal-only pre-release PE version builds
For pre-release builds:

1. Make a branch of this repo and of pltraining-bootstrap.
1. Edit the Puppetfile on this branch to point to your own fork and branch of pltraining-bootstrap.
1. Edit the build script in `./scripts` to reference the correct branch of this repo at build time.
  * Note this change does not need to be commited to the branch.
1. Download the PE master and agent installers and place them in a `file_cache` directory in the root of this repository.
1. Update the `$pe_version` in `bootstrap::params` in your branch of pltraining-bootstrap.
1. Make sure to add, commit, and push those changes.
1. The packer build should run as usual.

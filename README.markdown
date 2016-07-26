# Bootstrap CentOS VMs for training
Packer build scripts for master, training, student, or learning VMs. See
versioned release notes at [ReleaseNotes.md](ReleaseNotes.md).

## Usage

1. Install virtualbox, packer, and vmware ovftool and ensure the binaries are in the path.
1. Run setup script to download and deploy base images:
  * `setup.sh`
1. Run packer to build educationbase VM. 
  * `packer build -var-file=templates/learning.json templates/educationbase.json`
1. Run packer to complete VM build, the `--force` will replace any previous build artifacts.
  * `packer build --force -var-file=templates/learning.json templates/educationbuild.json`

For the master or training VMs, use `master.json` or `training.json`.
For the student VM, you don't need an educationbase or var-file:
  * `packer build templates/student.json`

## Detailed Usage

Packer scripts are provided in the `templates` directory. These depend on
packer (>= v0.10.0), vmware fusion, and ovftool. The packer builds pull 
directly from github and the master branch, so changes will need to be checked in.

The base VMs are the published puppetlabs vagrant boxes.  To download and
prepare them, run `setup.sh`. This will create the output, file_cache, and
packer_cache directories if they don't exist.  

The file_cache directory has a subfolder called "installers" for holding 
PE installer tarballs and another called gems for caching gems, the setup 
script will create any necessary directories if they don't exist. If you'd like
to keep those on a separate volume to save disk space, create symlinks before 
running the setup script.

The packer_cache directory is used by packer to store iso's for 

The common configuration options for the training, learning, and master vms
have been set up in educationbase.json and vm specific variables are set in
VMNAME.json

After the base VM is provisioned according to the settings in VMNAME.json, the
bootstrap can be applied using educationbuild.json.

First create a base VM without any bootstrap applied:
- `packer build -var-file=templates/learning.json templates/educationbase.json`

To initiate a packer build of the learning vm on the base vm:
- `packer build -var-file=templates/learning.json templates/educationbuild.json`

For the training vm follow the same two steps but with training.json:
- `packer build -var-file=templates/training.json templates/educationbase.json`
- `packer build -var-file=templates/training.json templates/educationbuild.json`

The Student VM is the only VM running Centos6 so it's build template is all in
student.json:
- `packer build templates/student.json`

There are also several AMI builds in templates. These don't require a base build.
To build these, set up the AWS builder requirements as described in the packer
documentation and use the following command:
- `packer build -var-file=templates/learning.json templates/awsbuild.json`

## Vagrant
There is a Vagrantfile that automates this process and builds on the
puppetlabs/centos-7.2-x86_64-nocm base box and the puppetlabs/cento-6.6-32-nocm
base box for the student VM. 

The Vagrant boxes will use the current local files for building rather than 
checking out the code from github. They have full write access, to be aware that
new files in the repo be created and existing files may change.

There are three boxes specified.

To start a student vagrant box:
- `vagrant up`

To start a training vagrant box for instructor use:
- `vagrant up training`

To start a learning vagrant box:
- `vagrant up learning`


## Building with pre-released modules and code
To develop the VMs, you need to use modules and other code that haven't yet
been merged to master or released to the forge. The non-vagrant VM build checks 
out code directly from github, so changes you make to the local filesystem won't 
be used, you need to push them to a branch and reference that branch 
in the build scripts:

1. Fork this repo and create a branch for your changes.
1. Update the build script to reference your namespace and branch
  * You don't need to push this change, packer reads the local copy.
  * You can also make temporary changes to the local packer json files without pushing.
1. If you're changes are in a module, update the Puppetfile with the correct reference.
1. Commit changes and push to your fork on github.
1. Run the build.
1. Iterate as needed.
1. When module changes are merged to master and/or released on the forge, 
  delete your education-build branch and build from master.

Note: Be careful that references to your namespace aren't included in PRs.

## Updating PE version
The version of PE used to build the VM is determined by the
pltraining-bootstrap module. To update the version, set the value of
`$pe_version` in `bootstrap::params`.

## Internal-only pre-release PE version builds
For pre-release builds:

1. Make a branch of this repo and of pltraining-bootstrap.
1. Edit the Puppetfile on this branch to point to your own fork and branch of
pltraining-bootstrap.
1. Edit the build script in `./scripts` to reference the correct branch of this
repo at build time.
  * Note this change does not need to be commited to the branch.
1. Download the PE master and agent installers and place them in a `file_cache`
directory in the root of this repository.
1. Update the `$pe_version` in `bootstrap::params` in your branch of
pltraining-bootstrap.
1. Make sure to add, commit, and push those changes.
1. The packer build should run as usual.

## Troubleshooting

### Setup script
If the initial setup script fails, delete the contents of `output` and rerun.

### Failed builds
VM builds will fail if the output artifacts already exist.  You can avoid that
by using the `--force` flag with packer.  If a build does fail on the OVA export
you can run the ovftool directly.  For example usage see `scripts/export-ova.sh`.


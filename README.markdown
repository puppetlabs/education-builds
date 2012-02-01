# Bootstrap CentOS VMs for training

## Initial Setup (first time):
- Enable web sharing in System Preferences if it is not already enabled
    - Click "Create Personal Website Folder" if `~/Sites` does not already exist
- Clone this repo to anywhere
- Download full CentOS DVD ISOs to anywhere
    - You only need the `1 of 2` ISO, but the torrent comes with 2
- Install [OVF Tool](http://www.vmware.com/resources/techresources/1013) from VMware's website

## Usage (what a human has to do):

### Starting point for each build:
- Ensure that the "Initial Setup" above is satisfied
- Run ./scripts/setup-bootstrap.sh
    - It will create `~/Sites/ks`
        - It will copy centos kickstart file into `~/Sites/ks`
        - It will download EPEL rpm into `~/Sites/ks`
        - It will download PE tarball into `~/Sites/ks`
        - It will clone four git repos into `~/Sites/ks`
    - It will create `~/Sites/dvd`
        - It will prompt for the location of the first DVD image (Protip: drag 'n drop the `.iso` to the terminal instead of typing the path)
        - It will mount the DVD image at `~/Sites/dvd`
    - It will enable php on your local apache for kickstart (prompts for password for sudo)
- Create a new VM (See "Creating the VM" below)
- For training VM:
    - At `boot:` prompt, enter `linux ks=http://192.168.XXX.1/~username/ks/centos.php`
    - At `boot:` prompt, enter `linux ks=http://192.168.XXX.1/~username/ks/centos.php?hostname=training.puppetlabs.lan` or something
- For learning VM:
    - At `boot:` prompt, enter `linux ks=http://192.168.XXX.1/~username/ks/centos.php?hostname=learn.localdomain`
- Wait 8 minutes (depends on bandwidth)
- Power off VM when prompted
- Package VM (see "Packaging the VM" below)
- ENSURE THAT PE INSTALLS WITH DEV TOOLS WITHOUT PROBLEMS
- Uh, `<insert upload directions from` [Puppetlabs sites](https://sites.google.com/a/puppetlabs.com/main/teams/professional-services/training/editing-the-training-vm) `here>`

### Creating the VM (Pre-kickstart):
- Create a blank VM of type CentOS (not 64bit)
- Choose to boot with an ISO, and choose `~/Sites/dvd/images/boot.iso`
- Choose to customize VM settings
- Name VM "centos-5.7-pe-2.0.1-vmware" (or as appropriate)
- Edit harddrive settings to use a 4GB disk *not* split into 2GB chunks
- Edit ram settings to be 512 MB
- Edit VM name to be "Puppet Training"
- Boot

### Packaging the VM (Post-kickstart):
- In VM settings:
    - Disconnect CD-ROM and set to Physical drive
- Create snapshot called `initial` (the VM should never have been booted after kickstart at this point)
- Quit VMWare
- Rename vm directory: `mv centos-5.7-pe-2.0.1-vmware.vmwarevm centos-5.7-pe-2.0.1-vmware`
- Remove any `.lck` and `.log` files from the VM directory
- `zip -r centos-5.7-pe-2.0.1-vmware.zip centos-5.7-pe-2.0.1-vmware` to create zip (should be ~450MB)
- Make vbox directory: `mkdir centos-5.7-pe-2.0.1-vbox`
- `cd` to vbox directory and invoke the `vmware2vbox.sh` script from PTB repo's `scripts` directory
- Zip vbox as above for vmware

## Automated Kickstart Tasks (What the kickstart install script does, in english):
- Modify root user password (for debug-login purposes)
- Install `epel` rpm, then `git`
- Clone `/usr/src/puppet` `/usr/src/facter` `/usr/src/mcollective` `/usr/src/puppetlabs-training-bootstrap`
- Kick off a puppet run on `/usr/src/puppetlabs-training-bootstrap/manifests/site.pp`
- Shutdown VM

## Automated Puppet Tasks (by module):
### bootstrap
- Set up root password, `.bashrc`
- Set up network sysconfig and hosts for 'puppet'
- Set up rc.local job to print IP to TTY after boot
- Remove cluttery /etc/puppet directory
- Start `sshd`

### localrepo
- Create local repo
- Add local `yumrepo` instance enabled

### pebase
- Create symlink at `/root/puppet-enterprise`
- At some point in the future: (currently in kickstart)
    - Grab PE tarball from the [direct link](https://pm.puppetlabs.com/puppet-enterprise/2.0.1/puppet-enterprise-2.0.1-el-5-i386.tar.gz)

### learning
- Copy in answer file
- Install PE with an exec resource and an answer file

### training
- Set up Yumrepo for `puppetlabs` disabled
- Disable `epel`, `base`, `updates`, and `extras`  Yumrepos
- Disable bluetooth and remove bluetooth packages

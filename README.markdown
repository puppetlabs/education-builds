# Bootstrap CentOS VMs for training

## Usage (what a human has to do):
- Clone this repo to anywhere
- Download full CentOS DVD iso
- Run ./scripts/setup-bootstrap.sh
    - It will create `~/Sites/ks`
        - It will copy centos kickstart file into `~/Sites/ks`
        - It will copy PE tarball into `~/Sites/ks`
        - It will clone four git repos into `~/Sites/ks`
    - It will create `~/Sites/dvd`
        - It will prompt for the location of the first DVD image (Protip: drag 'n drop the .iso to the terminal instead of typing the path)
        - It will mount the DVD image at `~/Sites/dvd`
  - It will enable php on your local apache for kickstart (prompts for password for sudo)
- Enable web sharing in System Preferences if it is not already enabled
- Create a new VM (See "Creating the VM" below)
- At `boot:` prompt, enter `linux ks=http://192.168.XXX.1/~username/ks/centos.php`
- Wait 8 minutes (depends on bandwidth)
- Power off VM when prompted
- Package VM (see "Packaging the VM" below)
- ENSURE THAT PE INSTALLS WITH DEV TOOLS WITHOUT PROBLEMS
- Uh, `<insert upload directions from Puppetlabs sites here>`

## Creating the VM (Pre-kickstart):
- Create a blank VM of type CentOS (not 64bit)
- Choose to boot with an ISO, and choose `~/Sites/dvd/images/boot.iso`
- Choose to customize VM settings
- Name VM "centos-5.7-pe-1.2.3-vmware" (or as appropriate)
- Edit harddrive settings to use a 4GB disk *not* split into 2GB chunks
- Edit ram settings to be 512 MB
- Edit VM name to be "Puppet Training"
- Boot

## Packaging the VM (Post-kickstart):
- In VM settings:
    - Disconnect CD-ROM and set to Physical drive
- Create snapshot called `initial` (the VM should never have been booted after kickstart at this point)
- Quit VMWare
- Rename vm directory: `mv centos-5.7-pe-1.2.3-vmware.vmwarevm centos-5.7-pe-1.2.3-vmware`
- Remove any `.lck` and `.log` files from the VM directory
- `zip -r centos-5.7-pe-1.2.3-vmware.zip centos-5.7-pe-1.2.3-vmware` to create zip (should be ~450MB)
- Make vbox directory: `mkdir centos-5.7-pe-1.2.3-vbox`
- `cd` to vbox directory and invoke the `vmware2vbox.sh` script from PTB repo's `scripts` directory
- Zip vbox as above for vmware

## Automated Kickstart Tasks:
- Modify root user password (for debug-login purposes)
- Install `epel` rpm, then `git`
- Clone `/usr/src/puppet` `/usr/src/facter` `/usr/src/mcollective` `/usr/src/puppetlabs-training-bootstrap`
- Kick off a puppet run on `/usr/src/puppetlabs-training-bootstrap/manifests/site.pp`
- Shutdown VM

## Automated Puppet Tasks (by module):
### bootstrap
- Set up root password, `.bashrc`
- Set up Yumrepo for `puppetlabs` disabled
- Disable `epel`, `base`, `updates`, and `extras`  Yumrepos
- Set up `host` entries (optional)
- Start `sshd`
- Disable bluetooth and remove bluetooth packages

### localrepo
- Create local repo
- Add local `yumrepo` instance enabled

### pebase
- Copy in master and dev answer files (via `source =>`)
- Create symlink at `/root/puppet-enterprise`
- Set up `/etc` directories for PE
- At some point in the future: (currently in kickstart)
    - Grab PE tarball from the [direct link](https://pm.puppetlabs.com/puppet-enterprise/1.2.3/puppet-enterprise-1.2.3-el-5-i386.tar.gz)

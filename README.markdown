# Bootstrap CentOS VMs for training

## Usage:
- Clone this repo to anywhere
- Download full CentOS DVD iso
- Run ./scripts/setup-bootstrap.sh
    - It will create `~/Sites/ks`
        - It will copy centos kickstart file into `~/Sites/ks`
        - It will copy PE tarball into `~/Sites/ks`
        - It will clone four git repos into `~/Sites/ks`
    - It will create `~/Sites/dvd`
        - It will prompt for the location of the DVD image (Protip: drag 'n drop the .iso to the terminal instead of typing the path)
        - It will mount the DVD image at `~/Sites/dvd`
  - It will enable php on your local apache for kickstart (prompts for password for sudo)
- Enable web sharing in System Preferences if it is not already enabled
- Boot a blank VM with `~/Sites/dvd/images/boot.iso`
- At `boot:` prompt, enter `linux ks=http://192.168.XXX.1/~username/ks/centos.php`
- Wait 30 minutes (depends on bandwidth for `yum update` et al)

## Kickstart Tasks:
- Modify root user password (for debug-login purposes)
- Install `epel` rpm, then `git`
- Clone `/usr/src/puppet` `/usr/src/facter` `/usr/src/mcollective` `/usr/src/puppetlabs-training-bootstrap`
- Kick off a puppet run on `/usr/src/puppetlabs-training-bootstrap/manifests/site.pp`
- Shutdown VM

## Puppet Tasks (by module):
### bootstrap
- Set up root password, `.bashrc`
- Set up Yumrepo for `puppetlabs` disabled
- Disable `epel`, `base`, and `updates` Yumrepos
- Set up `host` entries (optional)
- Start `sshd`

### localrepo
- Create local repo
- Add local `yumrepo` instance enabled

### pebase
- Copy in:
 - PE tarball from the [direct link](http://pm.puppetlabs.com/puppet-enterprise/1.1/puppet-enterprise-1.1-centos-5-x86_64.tar)
 - master and dev answer files (via `source =>`)
- Set up `/etc` directories for PE


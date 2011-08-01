# Bootstrap CentOS VMs for training
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


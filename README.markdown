# Bootstrap CentOS VMs for training
## Kickstart Tasks:
- Modify root user password (for debug-login purposes)
- Clone /usr/src/puppet /usr/src/facter /usr/src/mcollective /usr/src/puppetlabs-training-bootstrap
- Kick off a puppet run on /usr/src/puppetlabs-training-bootstrap/manifests/site.pp
- Shutdown VM

## Puppet Tasks (by module):
### bootstrap
- Set up root password, `.bashrc`
- Set up Yumrepos for `epel`, `puppetlabs` (disabled)
- Disable `base` and `updates` Yumrepos
- set up `host` entries (optional)
- start `sshd`

### localrepo
- Create local repo
- Add local `yumrepo` instance enabled

### pebase
- Copy in:
 - PE tarball from the [direct link](http://pm.puppetlabs.com/puppet-enterprise/1.1/puppet-enterprise-1.1-centos-5-x86_64.tar)
 - master and dev answer files (via `content =>`)
- set up `/etc` directories for PE


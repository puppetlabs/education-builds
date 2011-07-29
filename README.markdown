# Bootstrap CentOS VMs for training
## Kickstart Tasks:
- Modify root user password (for debug-login purposes)
- Clone /usr/src/puppet /usr/src/facter /usr/src/mcollective
- Kick off a puppet run
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
 - PE tarball
 - master and dev answer files
- set up `/etc` directories for PE


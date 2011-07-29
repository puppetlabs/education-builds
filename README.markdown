# Bootstrap CentOS VMs for training

## Kickstart Tasks:

- Modify root user password (for debug-login purposes)
- Clone /usr/src/puppet /usr/src/facter /usr/src/mcollective
- Kick off a puppet run

## Puppet Tasks:

- Set up root password, bashrc
- Set up Yumrepos for epel, puppetlabs
- Disable all Yumrepos
- Create local repo
- Add local Yumrepo instance
- Copy in:
 - PE tarball
 - master and dev answer files
- set up host entries (optional)
- start ssh



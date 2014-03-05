# Bootstrap CentOS VMs for training

## Initial Setup (first time):
- `mkdir ~/Sites` if `~/Sites` does not already exist
- Clone this repo to anywhere
- Download full 32-bit CentOS DVD ISOs to anywhere
    - You only need the `1 of 2` ISO, but the torrent comes with 2
    - If you put the iso file in ~/Sites/cache/ this Rakefile will autodetect and use it!
    - Do not use the 64-bit ISOs
- Install [OVF Tool](https://communities.vmware.com/community/vmtn/automationtools/ovf) from VMware's website
- Install [virtualbox](https://www.virtualbox.org/wiki/Downloads)
    - The bootstrap uses virtualbox to create the initial VM, so you need it even if you don't intend to run VMs in virtualbox
- Install [vagrant](http://www.vagrantup.com/downloads.html)
- Download and build [xorriso](http://freecode.com/projects/gnu-xorriso) from freecode.com
    - Follow the instructions in INSTALL to build and install xorriso
    - You can also install xorriso using homebrew: `brew install xorriso`
- Ensure you have all the Rakefile's required gems. 
    - At this time, the list include gpgme and nokogiri
    - (e.g. `sudo gem install gpgme`)

## Usage (what a human has to do):

- Ensure that the "Initial Setup" above is satisfied
- Run `rake init`
- Run `rake everything` to build the VM you want.
    - `rake everything vmos=Centos vmtype=training` will build a training vm
    - `rake everything vmos=Centos vmtype=learning` will build a learning vm
- Wait for it to finish, then find zipped-up ready-to-use VMs in ~/Sites/cache/

## Options:

When running the Rakefile to create new VMs, the following ENV vars can be set as needed:

- PEVERSION - eg. 3.2
- PESTATUS - latest or release
    - If release it will grab the released 3.2.z PE installer
    - If latest it will grab the latest build from neptune.puppetlabs.lan - so requires access to PuppetLabs VPN
- vboxheadless 
    - If set to 1, you will not see the VirtualBox window when the VM is created
- vmos - Centos or Debian
- vmtype - training or learning
- ptbrepo - URI for the repo with puppetlabs-training-bootstrap
- iso_file
    - The path to the OS iso file to use as a base. By default it uses the OS iso in the cache directory
- ptbbranch
    - branch for the repo, defaults to master
- ptbbranch_overide
    - If set to 1 the last used branch (master by default) will be used
- del - y or n
    - If yes, the existing VMs in the cache dir will be delete during rake clean
- mem - integer
    - Memory for the new VM, defaults to 1024


### Examples:

To build with the (unreleased) PE version undergoing testing installer being currently worked-on:

Note: You will need to connected to the Puppetlabs office network to do this!

`del=y rake clean && PEVERSION=3.2 PESTATUS=latest vboxheadless=1 vmos=Centos vmtype=training ptbbranch_override=1 del=y rake everything` 

To build with the released PE version installer: 
`del=y rake clean && PEVERSION=3.2 PESTATUS=release vboxheadless=1 vmos=Centos vmtype=training ptbbranch_override=1 del=y rake everything` 

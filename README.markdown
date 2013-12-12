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
- Download and build [xorriso](http://freecode.com/projects/gnu-xorriso) from freecode.com.
    - Follow the instructions in INSTALL to build and install xorriso
- Ensure you have all the Rakefile's required gems.  (e.g. `sudo gem install gpgme`)

## Usage (what a human has to do):

- Ensure that the "Initial Setup" above is satisfied
- Run `rake init`
- Run `rake everything` to build the VM you want.
    - `rake everything vmos=Centos vmtype=training` will build a training vm
    - `rake everything vmos=Centos vmtype=learning` will build a learning vm
- Wait for it to finish, then find zipped-up ready-to-use VMs in ~/Sites/cache/

## To Do:
- Support creation of Ubuntu/Debian-based VMs
    - currently one can only build CentOS-based VMs.

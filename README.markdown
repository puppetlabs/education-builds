# Bootstrap CentOS VMs for training

## Initial Setup (first time):
- `mkdir ~/Sites` if `~/Sites` does not already exist
- Clone this repo to anywhere
- Download full CentOS DVD ISOs to anywhere
    - You only need the `1 of 2` ISO, but the torrent comes with 2
    - If you put the iso file in ~/Sites/cache/ this Rakefile will autodetect and use it!
- Install [OVF Tool](https://communities.vmware.com/community/vmtn/automationtools/ovf) from VMware's website

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

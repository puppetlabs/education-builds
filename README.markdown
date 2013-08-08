# Bootstrap CentOS VMs for training

## Initial Setup (first time):
- Pre-mountain-lion:
    - Enable web sharing in System Preferences if it is not already enabled
    - Click "Create Personal Website Folder" if `~/Sites` does not already exist
- Mountain-lion:
    - Enable apache on your laptop: `sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist`
    - `mkdir ~/Sites` if `~/Sites` does not already exist
- Clone this repo to anywhere
- Download full CentOS DVD ISOs to anywhere
    - You only need the `1 of 2` ISO, but the torrent comes with 2
- Install [OVF Tool](http://www.vmware.com/resources/techresources/1013) from VMware's website

## Usage (what a human has to do):

### Starting point for each build:
- Ensure that the "Initial Setup" above is satisfied
- Run `rake init`
- Run `rake everything vmtype=Centos` to create the CentOS-based Training VMs used in the classroom.
- Wait for it to finish, then find zipped-up ready-to-use VMs in ~/Sites/cache/

## To Do:
- Support creation of Ubuntu/Debian-based VMs

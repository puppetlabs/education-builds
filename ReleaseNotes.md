## Version 5.14
* Classroom in a box build
* update to PE 2017.1.1
* pltraining-learning module merged to pltraining-bootstrap
* Cache docker images at build time
* Install cmake and several other new deps

## Version 5.12
* Cache agent packages in a better way
* Cache maci0/systemd and centos:7 docker images

## Version 5.11
* Updated cached packages

## Version 5.10
* PE 2016.5.1
* Dynamic puppetfile to support release branch

## Version 5.8

* Cloud template updates
* PE 2016.4.2
* Export a single ova/box artifact
 

## Version 5.7

* Build script improvments
* Build for Classroom in a box
* Pull in latest bootstrap changes

## Version 5.4

* Rake tasks for doing builds.
* Libvirt templates for vcmanager
* Puppetfiles to install build dependencies

## Version 5.3

* Cache docker images on master vm
* 2016.2 builds for AWS

## Version 5.2

* 2016.2 support

## Version 5.1

* 2016.1.2 support
* Converted build to use Virtualbox

## Version Master 4.1, Student 4.2

* 2016.1.1 support
* hostname fix for Centos 6 student VMs

## Version 4.0

* New preinstalled VM called "master" to replace training and puppetfactory VM
* refactor of pltraining-bootstrap and pltraining-learning modules for simpler implementation
* Install PE using the rake, not using puppet
* Improved shutdown in packer for LVM

## Version 3.3

* Cache missing dependency LVM

## Version 3.2

* 2015.3.1 build

## Version 3.1

* Use ruby and gem from AIO installer for r10k

## Version 3.0

* Support for 2015.3
* Use AIO installer for build

## Version 2.34

* Cache hocon gem
* Move scripts to pltraining-bootstrap

## Version 2.33

* Some additional cached gems


## Version 2.32

* Support for CentOS 6.7
* Support for 2015.2.1

## Version 2.31
* Timezone fix for base VMs

## Version 2.29
* Learning VM memory improvments

## Version 2.28
* Updated cached modules for offline

## Version 2.27
* 2015.2 offline classroom support
* Learning VM 2015.2 build
* LMS Centos7/2015.2 build

## Version 2.26
* 2015.2 build and removing defunct root certs
* Run puppet after learning VM build

## Version 2.25
* Rebuild offline yum cache at the end of the build

## Version 2.24
* Using role for LMS

## Version 2.23
* Build using Puppet 3.8.1 and Facter 2.4.4
* Clean yum cache at the end of build to save space

## Version 2.22

* Refactored to use roles

## Version 2.21
* PE 3.8.1 support

## Version 2.20
* Smaller VM footprint for LMS vm

## Version 2.19
* Centos 7 build for puppetfactory/infrastructure base VM
* Rakefile outputs progress
* Include PTB version in /etc/puppetlabs-release
* Get apache module for LVM self-hosted quest guide

## Version 2.18
* LMS vm build
* Clean up some files in /root left by build process
* updated enc_injector.rb script
* Changed external_node.rb to output yaml
* Removed timeout on ping in setup_classroom.sh

## Version 2.15
* The Rakefile has been refactored to be run on a blank VM.
* Added packer scripts to allow building of VM images from a host machine
* Lots of additions related to the windows classroom module
* Minimal student VM so that students don't have to download full vm

## Version 2.12
* We've now pinned and cached ALL versions of the Gems required.
* The timeout for the Console has been set to 1 million seconds.
* Added back the vagrant user and VirtualBox / VMWare extensions.
* Also removed per environment environment.conf based on docs and testing. Troubleshooting guide includes instructions on re-enabling it.

## Version 2.11
* All of the Forge modules have been updated in the cache - this means the Fundamentals capstone will work offline.
* We’ve removed the http://rubygems.org source from the /root/.gemrc file so that all gem installs are local. (We’ve also pinned versions of rspec and serverspec so they will work.) 
* The extraction of the PE tarball shouldn’t be interruptible.
* Moved to a metadata.json file instead of Modulefile.
* All of the metadata for modules is correct so `puppet module install` pulls in the right dependencies when you are online.
* Updated the RPMs we need for offline Practitioner. (Thanks for your help on this Gabe!)
* Set the timeout on the console to 27 hours so you should only have to log in twice.
* We got rid of the allow_virtual warning for `puppet agent` runs!
* I've fixed the VirtualBox duplicate MAC address (again).
* I've fixed VirtualBox still thinking it was attached to my DVD drive.
* A bunch of small, incremental changes.

## Version 2.6
* Added version numbers to the filename

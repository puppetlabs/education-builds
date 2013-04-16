#advanced module

This is the advanced module. It is used for the puppet advanced class to setup 3 different types of machines.  
    * `classroom.puppetlabs.vm` This system is the ca/puppetdb/report server for the classroom.  
    * `proxy.puppetlabs.vm` aka `irc.puppetlabs.vm` This server is used for haproxy and ircd.  
    * `yourname.puppetlabs.vm` For any system thats not the above, assume its a student system.  

The `advanced` class is used to lookup the system type based on its `$::hostname` fact.  
Each type of system will then have `advanced::classroom`,`advanced::proxy`,`advanced::agent` classified respectively. These classes then call classes in respective folders of the same name, i.e. The puppetdb setup for classroom can be found in `./manifests/classroom/puppetdb.pp` and is declared in `./manifests/classroom.pp`.

## Classroom (classroom.puppetlabs.vm)
1. Download a new centos 6+ virtual machine from [downloads](http://downloads.puppetlabs.vm)
2. Ensure your virtual machine is set to bridged networking mode.
3. Set the hostname to `classroom.puppetlabs.vm` and add `/etc/hosts` entries respectively
4. Install puppet enteprise (standard master installation) PE 2.7.1+ on EL6.3+
5. Add the `advanced` class to the puppet enterprise console (ENC).
6. classify `advanced` on `classroom.puppetlabs.vm`
7. Trigger an agent run using `puppet agent -t`
8. You should have a `puppetdb` environment with customized `auth.conf` and `site.pp`

## Proxy (proxy.puppetlabs.vm)
1. Download a new debian virtual machine from [downloads](http://downloads.puppetlabs.vm)
2. Ensure your virtual machine is set to bridged networking mode.
3. Setup the hostname to `proxy.puppetlabs.vm` and add `/etc/hosts` entries respectively
4. Add a `/etc/hosts` entry for `classroom.puppetlabs.vm`
5. Install puppet enteprise (standard agent installation) PE 2.6.1+ on
6. Add the enterprise extras repo (currently requires internet access )
 * `wget http://apt-enterprise.puppetlabs.com/puppetlabs-enterprise-release-extras_1.0-2_all.deb`  
 * `sudo dpkg -i puppetlabs-enterprise-release-extras_1.0-2_all.deb`  
 * `sudo apt-get update`  
7. Trigger an agent run using `puppet agent -t`
8. You should have a `haproxy` service and be able to type `irssi` and connect to the course irc channel
9. You can login to haproxy with the following  `http://puppet:puppet@yourip:9090`

Step 6 should go away once the debian VM is pre built or replaced with centos 6

## Student (yourname.puppetlabs.vm)
1. Download a new Centos 6.3+ virtual machine from [downloads](http://downloads.puppetlabs.vm)
2. Follow the exercise and lab guide no prep is needed from the instructor.

Older 5.8 Virtual machines will not work with the `puppetdb` section.
PE Versions older than 2.7.1 cannot be used for the `classroom.puppetlabs.vm` due to changes in how mcollective etc are configured

## Technical Breakdown
***

### Classroom (classroom.puppetlabs.vm) 
The following files are managed with this module
* `/etc/puppetlabs/puppet/auth.conf`  

We manage `auth.conf` because of the following modification  
`path ~ ^/facts/([^/]+)$
auth yes
method save
allow $1
`  

This allows for the first run of the students machines against `classroom.puppetlabs.vm` to work without having to add each hostname to this file (i.e.`allow yourname.puppetlabs.vm`). After their initial run they will be configured with `puppetdb::master::config` and this setting is moot as `inventory_server` in `puppet.conf` will be ignored.

There are raketasks defined for the classroom.puppetlabs.vm machine that automatically add three console parameters for the `default` group. This will run only the very first time you run `puppet agent -t` on `classroom.puppetlabs.vm`. The console parameters added are: `fact_stomp_server`, `stomp_password`, and `fact_is_puppetmaster`.

* `/etc/puppetlabs/puppet/manifests/site.pp`  

We use `site.pp` in this course as the `default` PE/ENC group will not work for the classification timing we have. The students will only do 2 to 3 runs against `classroom.puppetlabs.vm`. In order to classify the `advanced` module we use site.pp so we don't have to run the rake task in a loop i.e.  
`/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile nodegroup:add_all_nodes group=default RAILS_ENV=production`  

Using `site.pp` the `advanced` module is automatically classified during the first run. In addition as its not added to the PE Console/ENC, the students will not receive an error for the missing `advanced` class in their local `modulepath` when they do puppet runs against themselves ( using `classroom.puppetlabs.vm` as the `ENC`).

Both files are created using the `advanced::template` class. This class is designed to replace the default files created by installation and then not manage them (idempotance is based on the .old file in the same directory). This allows you to be ready for class but also to modify these files during demos in class. We do also manage `autosign.conf` in addition but ensure its content FYI.

### Proxy (proxy.puppetlabs.vm)
Two main classes configure your proxy node. `advanced::proxy::haproxy` and `advanced::irc::server`. The system is debian based mainly out of convenience as all of the packages for `charybdis` are available out of the box (that may change). The haproxy configuration will collect all `haproxy::balancermember` that the students will create. The `advanced::proxy::haproxy` class creates a `haproxy::listen` resources for `puppet00`. This is listening on port 8140 ( this is an agent node so no port conflict or customization is required ). Students should be able to collect the exported resource declared in `advanced::proxy::hostname` to allow for automatic setup of both client and server. The `advanced::irc::client` class includes the `irssi` class for irssi client setup.


### Student (yourname.puppetlabs.vm)
Student machines are configured by default ( as their hostnames are not matched to `classroom` or `proxy`. We configure them to use our puppetdb installation on the classroom using `puppetdb::master::config`. This allows them to export records to the other students in the room.  

The `advanced::agent::peadmin` class automatically sets up the .mcollective file (from a copy with ownership that allows it ). This allows the students to use the mco command line utility using the `classroom.puppetlabs.vm` as a broker system. The `advanced::irc::client` setups the `irssi` software to point to `irc.puppetlabs.vm`.  This irc host is exported during the labs and collected by the students. After they collected all `Host` resources with `classroom` tags they should be able to simply type `irssi`

For student machines that are running a version of PE older than 2.7.1, the `advanced::agent::mcofiles` class automatically copies the right certs and mcollective credentials files over as needed.

License
-------


Contact
-------
zack -@- puppetlabs.com

Support
-------

Please log tickets and issues at our [Projects site](http://projects.puppetlabs.com/projects/puppet-advanced/issues/new)

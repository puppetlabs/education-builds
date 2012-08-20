fundamentals

This is the fundamentals module, its used for creating accounts in the PE console, ssh, and NFS mounts
You can classify this module on both the master and the agents, it conditionally will configured both.
After the run of this module, you should classify the fundamentals::nfs::server module to create the
mount points. Once both are complete the agents should be classified and the nfs mounts will be configured
at /root/master_home for /homes/theirname

License
-------


Contact
-------
zack@puppetlabs.com

Support
-------

Please log tickets and issues at our [Projects site](http://projects.puppetlabs.com/projects/puppet-fundamentals/issues/new)

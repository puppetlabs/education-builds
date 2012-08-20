#fundamentals

This is the fundamentals module, its used for creating accounts in the PE console, ssh, and NFS mounts on both agent and master.
You can classify this module on both the master and the agents, it conditionally will configured both however the order matters.
1. Create an param in the PE console called "students" i.e. "zack,gary,ryan,james,luke,brad,ralph,hunter"
2. Classify only the master node in the PE console with the `fundamentals` module
3. Run `puppet agent -t` on the master
  + This will create all the PE console users
  + It will also create the unix accounts ( with home directories )
  + The PE console users idempotence is determined on the existance of their homes
4. Classify only the master node in the PE console with the `fundamentals::nfs::server`
5. Run `puppet agent -t` on the master
  + This will create the nfs mount records realitive to the users in the students array
  + You can't currently classify both these at the same time
6. Classify the `fundamentals` module for the default group.
7. Run `puppet agent -t` on the agents
  + This will create the NFS mount records for the agents
8. Profit

License
-------


Contact
-------
zack@puppetlabs.com

Support
-------

Please log tickets and issues at our [Projects site](http://projects.puppetlabs.com/projects/puppet-fundamentals/issues/new)

# PE Console RBAC APIs

Puppet Enterprise 3.7 introduced a new Role Based Access Control layer. This
enables you to manage the permissions of local users as well as those who are
created remotely, on a directory service in very granular detail.

This module exposes some of it to the Puppet DSL. Currently, it only manages
users. Roles, permissions, and groups will be added at a later time.

## Usage

``` Puppet
rbac_user { 'testing account':
    ensure       => 'present',
    name         => 'testing',
    display_name => 'Just a testing account',
    email        => 'testing@puppetlabs.com',
    password     => 'puppetlabs',
}
```

## Limitations

The API does not currently allow you to update existing users, other than to
revoke the account, or update the roles attached to the user. When you ensure an
`rbac_user` is absent, the record will not be removed, just marked as revoked.

Contact
-------

education@puppetlabs.com

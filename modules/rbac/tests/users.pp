rbac_user { 'testing account':
    ensure       => 'present',
    name         => 'testing',
    display_name => 'Just a testing account',
    email        => 'testing@puppetlabs.com',
    password     => 'puppetlabs',
    roles        => [ 'Operators' ],
}

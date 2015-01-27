Puppet::Type.newtype(:rbac_user) do
  desc "A Puppet Enterprise Console RBAC user"
  ensurable

  newparam(:name, :namevar => true) do
    desc "Login name of the user"
    newvalues /^\S+$/
  end

  newproperty(:display_name) do
    desc 'The displayed name of the user'

    # The API doesn't give us the capability to update these
    def insync?(is)
      return true
    end
  end

  newproperty(:email) do
    desc 'The email address of the user'
    newvalues /@/

    def insync?(is)
      return true
    end
  end

  newproperty(:password) do
    desc 'The plaintext password of the user.'

    def insync?(is)
      return true
    end
  end

  newproperty(:roles, :array_matching =>:all) do
    desc 'List of role IDs the user is a member of. The only attribute which can be changed after creation.'
    defaultto [3] # ID for the Viewer role

    # Make sure this is an integer... if it looks like an integer. Gross.
    munge do |value|
        num = value.to_i
        num == 0 ? value : num
    end

    def insync?(is)
      is.sort == provider.normalize_roles(@should).sort
    end
  end

  newproperty(:id) do
    desc 'The read-only ID of the user'
  end

  newproperty(:remote) do
    desc 'Remote users are managed by an external directory service'
  end

  newproperty(:superuser) do
    desc 'Whether this user has superuser privileges'
  end

  newproperty(:last_login) do
    desc 'The last login time for this user'
  end

end

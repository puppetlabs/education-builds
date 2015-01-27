require 'puppet/provider/rbac_api'

Puppet::Type.type(:rbac_user).provide(:ruby, :parent => Puppet::Provider::Rbac_api) do
  desc 'RBAC API provider for the rbac_user type'

  mk_resource_methods

  def self.instances
    Puppet::Provider::Rbac_api::get_response('/rbac-api/v1/users').collect do |user|
      Puppet.debug "Inspecting user #{user.inspect}"
      new(:ensure       => user['is_revoked'] ? :absent : :present,
          :id           => user['id'],
          :name         => user['login'],
          :display_name => user['display_name'],
          :email        => user['email'],
          :roles        => user['role_ids'],
          :remote       => user['is_remote'],
          :superuser    => user['is_superuser'],
          :last_login   => user['last_login'],
      )
    end
  end

  def self.prefetch(resources)
    vars = instances
    resources.each do |name, res|
      if provider = vars.find{ |v| v.name == res.title }
        res.provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    if @property_hash.empty?
      Puppet.debug "Creating new user #{resource.inspect}"

      [ :display_name, :email ].each do |prop|
        raise ArgumentError, 'name, email, and display_name are required attributes' unless resource[prop]
      end

      user = {
        'login'        => resource[:name],
        'email'        => resource[:email],
        'display_name' => resource[:display_name],
        'role_ids'     => normalize_roles(resource[:roles]),
      }
      Puppet::Provider::Rbac_api::post_response('/rbac-api/v1/users', user)

      if resource[:password]
        set_password(resource[:name], resource[:password])
      end
    else
      # if the user object exists, then it must have been disabled. Let's just re-enable it
      # and provide an opportunity to reset the password
      Puppet.debug "Re-enabling user #{@property_hash.inspect}"

      if @property_hash.has_key? :password
        set_password(@property_hash[:id], @property_hash[:password])
      end
    end

    @property_hash[:ensure] = :present
  end

  def destroy
    # We cannot actually remove the user, so we'll revoke it instead
    @property_hash[:ensure] = :absent
  end

  [ :name, :display_name, :email, :password ].each do |param|
    define_method "#{param}=" do |value|
      fail "The #{param} parameter cannot be changed after creation."
    end
  end

  [ :remote, :superuser, :last_login, :id ].each do |param|
    define_method "#{param}=" do |value|
      fail "The #{param} parameter is read-only."
    end
  end

  def flush
    # so, flush gets called, even on create()
    return if @property_hash[:id].nil?

    user = {
      'is_revoked'   => revoked?,
      'id'           => @property_hash[:id],
      'login'        => @property_hash[:name],
      'email'        => @property_hash[:email],
      'display_name' => @property_hash[:display_name],
      'role_ids'     => normalize_roles(@property_hash[:roles]),
      'is_remote'    => @property_hash[:remote],
      'is_superuser' => @property_hash[:superuser],
      'last_login'   => @property_hash[:last_login],
      'is_group'     => false,
    }

    Puppet.debug "Updating user #{user.inspect}"
    Puppet::Provider::Rbac_api::put_response("/rbac-api/v1/users/#{@property_hash[:id]}", user)
  end

private

  def revoked?
    @property_hash[:ensure] == :absent
  end

  def set_password(id, password)
    Puppet.debug "Setting password for #{id}"

    if id.class == String
      users = Puppet::Provider::Rbac_api::get_response('/rbac-api/v1/users')
      id    = users.select { |user| user['login'] == id }.first['id']

      Puppet.debug "Retrieved user id of #{id}"
    end

    token = Puppet::Provider::Rbac_api::post_response("/rbac-api/v1/users/#{id}/password/reset", nil).body

    reset = {
      'token'    => token,
      'password' => password,
    }

    Puppet::Provider::Rbac_api::post_response("/rbac-api/v1/auth/reset", reset)
  end

  def normalize_roles(list)
    roles = nil
    list.collect! do |item|
      next item if item.is_a? Fixnum

      # lazy load the available roles. Avoid the API call unless needed
      roles ||= Puppet::Provider::Rbac_api::get_response('/rbac-api/v1/roles')
      roles.find {|r| r['display_name'].downcase == item.downcase }['id']
    end
  end
end
module Puppet::Parser::Functions
  newfunction(:teams, :type => :rvalue, :doc => 'Returns an array of teams that this user is a member of.') do |args|
    raise(Puppet::ParseError, "teams(): Must pass 1 argument, not #{args.size}") if args.size != 1

    user  = args[0]
    raise(Puppet::ParseError, "teams(): Argument must be a username string") if user.class != String

    begin
      teams = function_hiera(['teams', ''])
      return '' if teams.nil?
    rescue Puppet::ParseError => e
      # Hiera must not be enabled on the master yet. Boo.
      return false
    end

    # [{"name"=>["member1", "member2"]}, {"name2"=>["member1"]}]

    #  Ruby 1.8, why must you vex me so?
    # teams.select { |name, members| members.include? user }.keys
    if ! teams.empty?
      teams = Hash[teams.select { |name, members| members.include? user }].keys
    end
    return teams if ! teams.empty?
    return ''
  end
end

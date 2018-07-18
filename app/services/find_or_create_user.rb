class FindOrCreateUser
  def self.call(username, name)
    user = User.find_or_create_by(username: username) do |u|
      u.name = name
      u.username = username
    end

    # There are a large number of things that expect a user to always have an associated
    # Person and Profile object. Make sure this user has one
    unless user.person && user.person.profile.present?
      account = Account.to_adapter.get!(user.id)
      update_status = account.update_with_password({ "username" => user.username, "name" => user.name })
      user.reload
    end

    user
  end
end

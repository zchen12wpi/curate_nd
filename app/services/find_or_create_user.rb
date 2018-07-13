class FindOrCreateUser
  def self.call(name)
    user = User.find_or_create_by(username: name) do |u|
      u.name = name
      u.username = name
    end

    # There are a large number of things that expect a user to always have an associated
    # Person and Profile object. Make sure this user has one
    unless user.person && user.person.profile.present?
      account = Account.to_adapter.get!(user.id)
      update_status = account.update_with_password({ "name" => user.username })
      user.reload
    end

    user
  end
end

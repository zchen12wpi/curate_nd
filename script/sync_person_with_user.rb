module SyncPersonWithUser
  module_function
  def sync
    @exceptions = []
    User.find_each do |user|
      begin
        Person.find_or_create_by_user(user)
      rescue LdapService::UserNotFoundError => e
        @exceptions << e.to_s
      end
    end
    if @exceptions.size > 0
      $stderr.puts(@exceptions.join("\n"))
      logger.error(@exceptions.join("\n"))
    end
  end
end

SyncPersonWithUser.sync

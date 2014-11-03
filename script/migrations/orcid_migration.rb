module Migrations
  module OrcidMigration
    module_function
    def build_profile_connection
      User.where("orcid_id IS NOT NULL AND orcid_id != ''").each do |user|
        if duplicate_orcids(user.orcid_id)
          puts "Duplicate Record orcid_id: #{user.orcid_id} for user_id: #{user.id}"
        else
          Orcid::ProfileConnection.new(user: user, orcid_profile_id: user.orcid_id).save
        end
      end
    end

    def duplicate_orcids(orcid_id)
      User.where("orcid_id = ?", orcid_id).size > 1
    end
  end
end

Migrations::OrcidMigration.build_profile_connection

class Ability
  include Hydra::Ability

  include Curate::Ability

  def custom_permissions
    @permitted_work_types ||= WorkTypePermissions.new(user: current_user)

    Curate.configuration.registered_curation_concern_types.each do |work_type|
      # Blacklisting Create for work types UNLESS you have permission
      unless @permitted_work_types.allow?(work_type)
        # Show, Edit, Update, and Destroy are determined by the access controls
        # on the work.
        cannot :create, work_type.constantize
      end

      # Access to ETD-specifc functions is limited to names in etd_manager_permission.yml
      unless EtdManagers.include?(current_user)
        cannot [:manage], EtdVocabulary
        cannot [:manage], TemporaryAccessToken
      end
    end
  end
end

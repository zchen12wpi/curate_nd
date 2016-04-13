# Ability defines the authorization logic used by cancan
class Ability
  include Hydra::Ability

  include Curate::Ability

  def custom_permissions
    @user_work_type_policy ||= WorkTypePolicy.new(user: current_user)

    Curate.configuration.registered_curation_concern_types.each do |work_type|
      # Blacklisting Create for work types UNLESS explicitly authorized
      unless @user_work_type_policy.authorized_for?(work_type)
        # Show, Edit, Update, and Destroy are determined by the access controls
        # on the work.
        cannot :create, work_type.constantize
      end

      # Access to ETD-specific functions is limited to names in etd_manager_permission.yml
      unless EtdManagers.include?(current_user)
        cannot [:manage], EtdVocabulary
        cannot [:manage], TemporaryAccessToken
      end
    end
  end
end

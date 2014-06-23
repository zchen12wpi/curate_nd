class Ability
  include Hydra::Ability

  include Curate::Ability

  # Define any customized permissions here.
  def custom_permissions
    @work_type_permissions ||= WorkTypePermissions.new(current_user)

    Curate.configuration.registered_curation_concern_types.each do |work_type|
      #The access is controlled by the work_type_permission.yml file
      #For a work, all the registered users will be given create access
      #unless a group id is specified instead of 'all' in the yml file.
      if !@work_type_permissions.is_permitted?(work_type)
        #Only concerned with work creation.
        #Edit can be controlled by access permissions settings for an object
        cannot :create, work_type.constantize
      end
    end
    # Limits deleting objects to a the admin user
    #
    # if current_user.admin?
    #   can [:destroy], ActiveFedora::Base
    # end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end
end

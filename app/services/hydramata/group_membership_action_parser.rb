# This module is used to take a params hash from the Group edit form (it uses nested attributes)
# and decide what action needs to happen for each member listed in the Group.
# The possibilities are: none, create, destroy

module Hydramata::GroupMembershipActionParser

  def self.convert_params(params, current_user)

     action = self.decide_membership_action(params)
     self.build_params(params, action, current_user)

  end

  private

  # Parse the params from the Group update form and decide the action
  def self.decide_membership_action(params)

    action=[]
    #validate prescence of required params
    if !params["hydramata_group"]["title"].nil? and !params["hydramata_group"]["description"].nil? and !params["hydramata_group"]["members_attributes"].nil?
      params["hydramata_group"]["members_attributes"].each do |key, value|
        if value["_destroy"] == "true" && value["id"].present?
          #remove member
          action << "destroy"
        elsif value["_new"] == "true" && value["id"].present?
          #add member
          action << "create"
        else
          action << "none"
        end
      end

    else
      raise Exception, "Exception placeholder"
    end
    action

  end

  # Build the param hash to be used by GroupMembershipForm
  def self.build_params(params, action, current_user)
    new_params_aggregate = []

    if !params.has_key?("group_member") || !params["group_member"].has_key?("edit_users_ids")
      return { group_id: params[:id], current_user: current_user, title: params["hydramata_group"]["title"], description: params["hydramata_group"]["description"], members: [], no_record_editors: true }
    end
    action.each_with_index do |member_action, index|
      person_id = params["hydramata_group"]["members_attributes"][index.to_s]["id"]
      person_name = params["hydramata_group"]["members_attributes"][index.to_s]["name"]
      role = person_id.present? && params["group_member"]["edit_users_ids"].include?(person_id) ? "manager" : "member"
      new_params_hash = Hash[person_id: person_id, person_name: person_name, action: member_action, role: role]
      new_params_aggregate << new_params_hash
    end
    { group_id: params[:id], current_user: current_user, title: params["hydramata_group"]["title"], description: params["hydramata_group"]["description"], members: new_params_aggregate, no_record_editors: false }
  end


end

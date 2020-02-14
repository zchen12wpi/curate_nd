class CurationConcern::GenericWorksController < CurationConcern::BaseController
  respond_to(:html)
  with_themed_layout '1_column'

  def new
    setup_form
  end

  def create
    return unless verify_acceptance_of_user_agreement!
    reset_organization_if_necessary
    reset_administrative_unit_if_necessary
    validations = validate_permission_changes
    if validations[:valid] && actor.create
      after_create_response
    else
      flash[:error] = validations[:notice]
      setup_form
      respond_with(:curation_concern, curation_concern) do |wants|
        wants.html { render 'new', status: :unprocessable_entity }
      end
    end
  end

  def after_create_response
    report_notification_messages
    respond_with(:curation_concern, curation_concern) do |wants|
      wants.html { redirect_to common_object_path(curation_concern) }
    end
  end

  def report_notification_messages
    actor.notification_messages.each do |message|
      flash[:notice] ||= []
      flash[:notice] << t(message.message_id, scope: [:curate, :notification_messages], pid: message.target_pid)
    end
  end
  protected :after_create_response

  # Override setup_form in concrete controllers to get the form ready for display
  def setup_form
    if action_name == 'new' && curation_concern.respond_to?(:contributor)
      curation_concern.contributor << current_user.name if curation_concern.contributor.empty? && !current_user.can_make_deposits_for.any?
    end
    curation_concern.record_editors << current_user.person if curation_concern.record_editors.blank? && action_name == 'new'
    curation_concern.record_editors.build
    curation_concern.record_editor_groups.build
    curation_concern.record_viewers.build
    curation_concern.record_viewer_groups.build
  end
  protected :setup_form

  def verify_acceptance_of_user_agreement!
    if contributor_agreement.is_being_accepted?
      return true
    else
      # Calling the new action to make sure we are doing our best to preserve
      # the input values; Its a stretch but hopefully it'll work
      self.new
      respond_with(:curation_concern, curation_concern) do |wants|
        wants.html {
          flash.now[:error] = "You must accept the contributor agreement"
          render 'new', status: :conflict
        }
      end
      return false
    end
  end
  protected :verify_acceptance_of_user_agreement!

  def show
    respond_with(curation_concern)
  end

  def edit
    setup_form
    respond_with(curation_concern)
  end

  def update
    reset_organization_if_necessary
    reset_administrative_unit_if_necessary
    validations = validate_permission_changes
    if validations[:valid] && actor.update
      after_update_response
    else
      flash[:error] = validations[:notice]
      setup_form
      respond_with(:curation_concern, curation_concern) do |wants|
        wants.html { render 'edit', status: :unprocessable_entity }
      end
    end
  end

  def after_update_response
    report_notification_messages
    if actor.visibility_changed?
      redirect_to confirm_curation_concern_permission_path(curation_concern)
    else
      respond_with(:curation_concern, curation_concern) do |wants|
        wants.html { redirect_to common_object_path(curation_concern) }
      end
    end
  end
  protected :after_update_response

  register :actor do
    CurationConcern::Utility.actor(curation_concern, current_user, attributes_for_actor)
  end

  def attributes_for_actor
    return params[hash_key_for_curation_concern] if cloud_resources_to_ingest.nil?
    params[hash_key_for_curation_concern].merge!(:cloud_resources=>cloud_resources_to_ingest)
  end

  def hash_key_for_curation_concern
    curation_concern_type.name.underscore.to_sym
  end

  # TODO: Normalize the following two methods
  def reset_organization_if_necessary
    return unless curation_concern.respond_to?(:organization)
    if params.has_key?(hash_key_for_curation_concern.to_s) && !params[hash_key_for_curation_concern.to_s].has_key?("organization")
      params[hash_key_for_curation_concern.to_s].merge!('organization' => [""])
    end
  end

  def reset_administrative_unit_if_necessary
    return unless curation_concern.respond_to?(:administrative_unit)
    if params.has_key?(hash_key_for_curation_concern.to_s) && !params[hash_key_for_curation_concern.to_s].has_key?("administrative_unit")
      params[hash_key_for_curation_concern.to_s].merge!('administrative_unit' => [""])
    end
  end

  private

  def validate_permission_changes
    # validate combinations of changes with editors & viewers
    new_editors = collect_perm_changes(find_attributes("record_editors_attributes"))
    new_viewers = collect_perm_changes(find_attributes("record_viewers_attributes"))
    valid_editors = valid_editors?(new_editors, new_viewers)
    return valid_editors unless valid_editors[:valid]
    valid_viewers = valid_viewers?(new_editors, new_viewers)
    return valid_viewers unless valid_viewers[:valid]

    new_editor_groups = collect_perm_changes(find_attributes("record_editor_groups_attributes"))
    new_viewer_groups = collect_perm_changes(find_attributes("record_viewer_groups_attributes"))
    valid_editor_groups = valid_editor_groups?(new_editor_groups, new_viewer_groups)
    return valid_editor_groups unless valid_editor_groups[:valid]
    valid_viewer_groups = valid_viewer_groups?(new_editor_groups, new_viewer_groups)
    return valid_viewer_groups unless valid_viewer_groups[:valid]

    { valid: true, notice: nil }
  end

  def valid_editors?(editors, viewers)
    return { valid: true } unless editors.has_key?(:create)
    return { valid: true } if editors[:create].empty?
    editors[:create].each do |id|
      return { valid: false,
               notice: 'Attempting to add same user as both editor and viewer' } if (curation_concern.record_viewers.map(&:pid).include?(id) &&
               !(viewers.has_key?(:remove) && viewers[:remove].include?(id))) ||
               (viewers.has_key?(:create) && viewers[:create].include?(id))
    end
    { valid: true }
  end

  def valid_editor_groups?(editors, viewers)
    return { valid: true } unless editors.has_key?(:create)
    return { valid: true } if editors[:create].empty?
    editors[:create].each do |id|
      return { valid: false,
               notice: 'Attempting to add same group as both editor and viewer' } if
               (curation_concern.record_viewer_groups.map(&:pid).include?(id) &&
               !(viewers.has_key?(:remove) && viewers[:remove].include?(id))) ||
               (viewers.has_key?(:create) && viewers[:create].include?(id))
    end
    { valid: true }
  end

  def valid_viewers?(editors, viewers)
    return { valid: true } unless viewers.has_key?(:create)
    return { valid: true } if viewers[:create].empty?
    viewers[:create].each do |id|
      return { valid: false,
               notice: 'Attempting to add same user as both editor and viewer' } if
               (curation_concern.record_editors.map(&:pid).include?(id) &&
               !(editors.has_key?(:remove) && editors[:remove].include?(id))) ||
               (editors.has_key?(:create) && editors[:create].include?(id))
    end
    { valid: true }
  end

  def valid_viewer_groups?(editors, viewers)
    return { valid: true } unless viewers.has_key?(:create)
    return { valid: true } if viewers[:create].empty?
    viewers[:create].each do |id|
      return { valid: false,
               notice: 'Attempting to add same group as both editor and viewer' } if (curation_concern.record_editor_groups.map(&:pid).include?(id) &&
               !(editors.has_key?(:remove) && editors[:remove].include?(id))) ||
               (editors.has_key?(:create) && editors[:create].include?(id))
    end
    { valid: true }
  end

  def collect_perm_changes(perms_to_validate)
    CurationConcern::WorkPermission.decide_action(perms_to_validate, params[:action])
  end

  def find_attributes(attr_key)
    if params.has_key?(hash_key_for_curation_concern.to_s) && params[hash_key_for_curation_concern.to_s].has_key?(attr_key)
      return params[hash_key_for_curation_concern.to_s][attr_key]
    end
    {}
  end
end

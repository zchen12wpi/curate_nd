# Not all work types can be created by all users. This policy object answers
# whether a user is authorized to create a given work type.
#
# Rules are defined in config/work_type_policy_rules.yml
class WorkTypePolicy
  def initialize(user: current_user, policy_rules: WORK_TYPE_POLICY_RULES)
    self.user = user
    self.policy_rules = policy_rules
  end

  def authorized_for?(work_type)
    rules = rules_for(work_type)
    case rules
    when 'all' then true
    when 'nobody' then false
    else user_has_privileged_group?(rules)
    end
  end

  private

  attr_accessor :policy_rules, :user

  def rules_for(work_type)
    return 'nobody' unless policy_rules.key?(work_type)
    work_type_rules = policy_rules.fetch(work_type)
    return 'nobody' if work_type_rules.blank?
    work_type_rules.fetch('open') { 'nobody' }
  end

  def user_groups
    @user_groups ||= user.groups
  end

  def user_has_privileged_group?(group_keys)
    privileged_groups = Array.wrap(group_keys)
    users_privileged_groups = user_groups & privileged_groups
    users_privileged_groups.any?
  end
end

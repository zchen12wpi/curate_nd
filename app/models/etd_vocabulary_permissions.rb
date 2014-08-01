class EtdVocabularyPermissions
  def initialize( current_user )
    @user = current_user
  end

  def can_manage_etd?
    etd_manager_usernames.include?(@user.user_key)
  end

  def etd_manager_usernames
    @etd_manager_usernames ||= load_managers
  end

  private

  def load_managers
    manager_config = "#{::Rails.root}/config/etd_manager_usernames.yml"
    if File.exist?(manager_config)
      content = IO.read(manager_config)
      YAML.load(ERB.new(content).result).fetch(Rails.env).
          fetch('etd_manager_usernames')
    else
      logger.warn "Unable to find etd managers file: #{manager_config}"
      []
    end
  end
end
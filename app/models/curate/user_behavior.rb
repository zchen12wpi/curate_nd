module Curate
  # User - An Account that is assigned to a human; A User has a one to one relationship with a Person
  module UserBehavior
    extend ActiveSupport::Concern

    included do
      include Curate::UserBehavior::Base
      include Curate::UserBehavior::WithAssociatedPerson
      include Curate::UserBehavior::Delegates

      # EVERTHING BELOW HERE ADDED FROM SUFIA::USER
      # Connects this user object to Blacklight's Bookmarks and Folders.
      include Blacklight::User
      include Hydra::User

      delegate :can?, :cannot?, :to => :ability

      # set this up as a messageable object
      acts_as_messageable

      # Users should be able to follow things
      acts_as_follower
      # Users should be followable
      acts_as_followable

      # Setup accessible (or protected) attributes for your model
      deprecated_attr_accessible  *permitted_attributes
    end

    # Format the json for select2 which requires just an id and a field called text.
    # If we need an alternate format we should probably look at a json template gem
    def as_json(opts = nil)
      {id: user_key, text: display_name ? "#{display_name} (#{user_key})" : user_key}
    end

    def email_address
      return self.email
    end

    def name
      return self.display_name.titleize || self.user_key rescue self.user_key
    end

    # Redefine this for more intuitive keys in Redis
    def to_param
      # hack because rails doesn't like periods in urls.
      user_key.gsub(/\./, '-dot-')
    end

    # method needed for trophies
    def trophies
      trophies = Trophy.where(:user_id => self.id)
      return trophies
    end

    #method to get the trophy ids without the namespace included
    def trophy_ids
      trophies.map { |t| "#{Sufia.config.id_namespace}:#{t.generic_file_id}" }
    end

    # method needed for messaging
    def mailboxer_email(obj=nil)
      return nil
    end

    # The basic groups method, override or will fallback to Sufia::Ldap::User
    def groups
      return self.group_list ? self.group_list.split(";?;") : []
    end

    def ability
      @ability ||= ::Ability.new(self)
    end

    module ClassMethods

      def permitted_attributes
        [:email, :login, :display_name, :address, :admin_area,
          :department, :title, :office, :chat_id, :website, :affiliation,
          :telephone, :avatar, :group_list, :groups_last_update, :facebook_handle,
          :twitter_handle, :googleplus_handle]
      end

      def current
        Thread.current[:user]
      end

      def current=(user)
        Thread.current[:user] = user
      end

      def from_url_component(component)
        User.find_by_user_key(component.gsub(/-dot-/, '.'))
      end

    end
  end
end

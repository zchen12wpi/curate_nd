require 'morphine'
module CurationConcern
  module Embargoable
    extend ActiveSupport::Concern

    # Embargo is not a proper citizen in the sufia model. Hence the override.
    # Embargo, as implemented in HydraAccessControls, prevents something from
    # being seen until the release date, then is public.
    module VisibilityOverride
      def visibility= value
        if value == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO
          super(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC)
        else
          self.embargo_release_date = nil
          super(value)
        end
      end

      def visibility
        if read_groups.include?(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC) &&
          embargo_release_date
          return Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO
        end
        super
      end
    end

    included do
      include Hydra::AccessControls::WithAccessRight
      include CurationConcern::Embargoable::VisibilityOverride
      include Morphine

      validates :embargo_release_date, date_format: true
      before_save :write_embargo_release_date, prepend: true

      register :embargoable_persistence_container do
        self.datastreams["rightsMetadata"]
      end
    end

    def write_embargo_release_date
      if defined?(@embargo_release_date)
        embargoable_persistence_container.embargo_release_date = @embargo_release_date
      end
      true
    end
    protected :write_embargo_release_date

    def embargo_release_date=(value)
      @embargo_release_date = begin
        value.present? ? value.to_date : nil
      rescue NoMethodError, ArgumentError
        value
      end
    end

    def embargo_release_date
      @embargo_release_date || embargoable_persistence_container.embargo_release_date
    end

    # override method from Hydra::AccessControls::Visibility so the registered group gets removed when changing to public access
    def public_visibility!
      visibility_will_change! unless visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      self.datastreams["rightsMetadata"].permissions({:group=>Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC}, "read")
      self.datastreams["rightsMetadata"].permissions({:group=>Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED}, "none")
    end
  end
end

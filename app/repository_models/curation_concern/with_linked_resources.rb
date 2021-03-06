module CurationConcern
  module WithLinkedResources
    extend ActiveSupport::Concern

    included do
      include ActiveFedora::RegisteredAttributes

      attribute :linked_resource_urls, multiple: true

      has_many :linked_resources, property: :is_part_of

      after_destroy :after_destroy_cleanup_linked_resources
    end

    def after_destroy_cleanup_linked_resources
      linked_resources.each(&:destroy)
    end

  end
end

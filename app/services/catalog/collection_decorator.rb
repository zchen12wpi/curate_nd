module Catalog
  module CollectionDecorator
    def self.call(identifier, data_source: ActiveFedoraAdapter)
      data_source.call(identifier)
    end

    module FakeAdapter
      def self.call(identifier)
        identifier
      end
    end

    module ActiveFedoraAdapter
      def self.call(pid)
        ActiveFedora::Base.find(pid, cast: true)
      end
    end
  end
end

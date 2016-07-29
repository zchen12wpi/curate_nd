module Catalog
  module CollectionDecorator
    def self.call(scope, data_source: ActiveFedoraAdapter)
      identifier = pid_from_scope(scope)
      data_source.call(identifier)
    end

    def self.pid_from_scope(scope, delimiter: '/')
      return '' if scope.nil? || scope.empty?
      slug = scope.split(delimiter).last
      extract_id(slug)
    end

    def self.title_from_scope(scope, delimiter: '/')
      return '' if scope.nil? || scope.empty?
      slug = scope.split(delimiter).last
      extract_title(slug)
    end

    def self.extract_id(slug, delimiter: '|')
      slug.split(delimiter).last.to_s
    end

    def self.extract_title(slug, delimiter: '|')
      slug.split(delimiter).first.to_s
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

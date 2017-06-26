module Catalog
  module CollectionDecorator
    def self.call(scope, data_source: ActiveFedoraAdapter)
      identifier = pid_from_scope(scope)
      data_source.call(identifier)
    end

    def self.pid_from_scope(scope, delimiter: '/')
      return '' if scope.nil? || scope.empty?
      slug = split_scope(scope, delimiter: delimiter).last
      extract_id(slug)
    end

    def self.title_from_scope(scope, delimiter: '/')
      return '' if scope.nil? || scope.empty?
      slug = split_scope(scope, delimiter: delimiter).last
      extract_title(slug)
    end

    # @note I'm checking Hash in this case as the tests are very fast (and I don't want to load ActionController::Parameters for those tests)
    # @see ./lib/curate/action_controller-parameters_spec.rb for assertion that ActionController::Parameters is a Hash
    def self.split_scope(scope, delimiter: '/')
      if scope.is_a?(Hash)
        split_scope(scope.values.first, delimiter: delimiter)
      elsif scope.is_a?(Array)
        split_scope(scope.first, delimiter: delimiter)
      else
        scope.split(delimiter)
      end
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

# frozen_string_literal: true

module Api
  class WorkMetadataFormatter
    attr_reader :work_id, :remaining_content, :user_id

    def initialize(content:, user:)
      @work_id = content[:work_id]
      @remaining_content = content.except(:work_id)
      @user_id = user
    end

    def valid?
      return false unless work_id
      return false unless user_id

      true
    end

    def initial_metadata
      metadata_hash = remaining_content
      metadata_hash['@context'] = {} unless metadata_hash['@context']
      metadata_hash['@context']['frels'] = 'info:fedora/fedora-system:def/relations-external#'
      metadata_hash['@context']['dc'] =  'http://purl.org/dc/terms/'
      metadata_hash['@context']['nd'] =  'https://library.nd.edu/ns/terms/'
      metadata_hash['@context']['und'] = 'https://curate.nd.edu/show/'
      metadata_hash['@id'] = "und:#{work_id}" unless metadata_hash['@id']
      metadata_hash['nd:afmodel'] = 'Document' unless metadata_hash['nd:afmodel']
      metadata_hash['nd:owner'] = user_id.to_s unless metadata_hash['nd:owner']
      metadata_hash['nd:accessEdit'] = user_id.to_s unless metadata_hash['nd:accessEdit']
      metadata_hash['nd:accessReadGroup'] = 'private' unless metadata_hash['nd:accessReadGroup']
      JSON.dump(metadata_hash)
    end
  end
end

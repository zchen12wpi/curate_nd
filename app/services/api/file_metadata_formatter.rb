# frozen_string_literal: true

module Api
  # FileMetadataFormatter creates default metadata for uplaofed Generic Files
  class FileMetadataFormatter
    attr_reader :work_id, :file_id, :file_name, :remaining_content, :user_id

    def initialize(content:, user:)
      @work_id = content[:work_id]
      @file_id = content[:file_id]
      @file_name = content[:file_name]
      @remaining_content = content.except(:work_id, :file_id, :file_name)
      @user_id = user
    end

    def valid?
      return false unless work_id
      return false unless file_id
      return false unless file_name
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
      metadata_hash['@id'] = "und:#{file_id}"
      metadata_hash['nd:filename'] = file_name.to_s
      metadata_hash['dc:title'] = file_name.to_s
      metadata_hash['nd:afmodel'] = 'GenericFile'
      metadata_hash['nd:accessReadGroup'] = 'private'
      metadata_hash['frels:isPartOf'] = "und:#{work_id}"
      metadata_hash['nd:owner'] = user_id.to_s
      metadata_hash['nd:accessEdit'] = user_id.to_s
      JSON.dump(metadata_hash)
    end
  end
end

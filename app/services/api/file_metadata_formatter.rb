module Api
  class FileMetadataFormatter
    attr_reader :work_id, :file_id, :file_name, :remaining_content, :user_id

    def initialize(content:)
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
      return false unless use_name
      true
    end

    def initial_metadata
      metadata_hash['@id'] = "und:#{file_id}"
      metadata_hash['nd:filename'] = "#{file_name}"
      metadata_hash['dc:title'] = "#{file_name}"
      metadata_hash['nd:afmodel'] = "GenericFile"
      metadata_hash['nd:accessReadGroup'] = "private"
      metadata_hash['frels:isPartOf'] = "und:#{work_id}"
      metadata_hash['nd:owner'] = "#{user_id}"
      metadata_hash['nd:accessEdit'] = "#{user_id}"
      JSON.dump(metadata_hash)
    end
  end
end

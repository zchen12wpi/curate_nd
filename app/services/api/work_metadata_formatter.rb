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
      metadata_hash['@id'] = "und:#{work_id}"
      metadata_hash['nd:afmodel'] = "Document"
      metadata_hash['nd:owner'] = "#{user_id}"
      metadata_hash['nd:accessEdit'] = "#{user_id}"
      metadata_hash['nd:accessReadGroup'] = "private"
      JSON.dump(metadata_hash)
    end
  end
end

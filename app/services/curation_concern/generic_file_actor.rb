module CurationConcern
  class GenericFileActor < CurationConcern::BaseActor

    def create
      # Get the list of files, then for each file, go through the creation process
      files = attributes.delete(:file).to_a
      times = 0
      while times < files.length do
        @file = files[times]
        attach_files && download_create_cloud_resources &&
        apply_access_permissions
        times += 1
      end
      return true
    end

    def update
      super { update_file  && download_create_cloud_resources }
    end

    def rollback
      update_version
    end

    def cloud_resources
      @cloud_resources ||= Array(@cloud_resources).flatten.compact
    end

    def download_create_cloud_resources
      cloud_resources.all? do |resource|
        update_cloud_resource(resource)
      end
    end

    protected
    def update_file
      file = attributes.delete(:file)
      title = attributes[:title]
      title ||= file.original_filename if file
      curation_concern.label = title
      if file
        CurationConcern::Utility.attach_file(curation_concern, user, file)
      else
        true
      end
    end

    def attach_files
        generic_file = GenericFile.new
        generic_file.file = @file
        generic_file.label = @file.original_filename
        generic_file.batch = curation_concern
        Sufia::GenericFile::Actions.create_metadata(
          generic_file, user, curation_concern.parent.pid
        )
        generic_file.embargo_release_date = curation_concern.parent.embargo_release_date
        generic_file.visibility = visibility
        CurationConcern::Utility.attach_file(generic_file, user, @file)
    end

    def add_cloud_resources
      cloud_resources.all? do |resource|
        attach_cloud_resource(resource)
      end
    end

    def attach_cloud_resource(cloud_resource)
      return true if ! cloud_resource.present?
      file_path=cloud_resource.download_content_from_host
      if  valid_file?(file_path)
        cloud_resource = File.open(file_path)
        generic_file = GenericFile.new
        generic_file.file = cloud_resource
        generic_file.label = @file.filename
        Sufia::GenericFile::Actions.create_metadata(
            generic_file, user, curation_concern.pid
        )
        generic_file.embargo_release_date = curation_concern.embargo_release_date
        generic_file.visibility = visibility
        CurationConcern::Utility.attach_file(generic_file, user, cloud_resource,File.basename(cloud_resource))
        File.delete(cloud_resource)
      end
    rescue ActiveFedora::RecordInvalid
      false
    end


    def update_version
      version_to_revert = attributes.delete(:version)
      return true if version_to_revert.blank?
      return true if version_to_revert.to_s ==  curation_concern.current_version_id

      revision = curation_concern.content.get_version(version_to_revert)
      mime_type = revision.mimeType.empty? ? "application/octet-stream" : revision.mimeType
      options = { label: revision.label, mimeType: mime_type, dsid: 'content' }
      curation_concern.add_file_datastream(revision.content, options)
      curation_concern.record_version_committer(user)
      curation_concern.save
    end

    def update_cloud_resource(cloud_resource)
      return true if ! cloud_resource.present?
      file_path=cloud_resource.download_content_from_host
      if file_path.present? && File.exists?(file_path) && !File.zero?(file_path)
        cloud_resource = File.open(file_path)
        title = attributes[:title]
        title ||= File.basename(cloud_resource)
        curation_concern.label=title
        CurationConcern::Utility.attach_file(curation_concern, user, cloud_resource,File.basename(cloud_resource))
        File.delete(cloud_resource)
      end
    rescue ActiveFedora::RecordInvalid
      false
    end

    def pid_for_object_to_copy_permissions_from
      curation_concern.batch.pid
    end
  end
end

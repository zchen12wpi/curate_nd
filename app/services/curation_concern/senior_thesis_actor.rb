require File.expand_path('../base_actor/doi_assignable', __FILE__)
module CurationConcern
  class SeniorThesisActor < CurationConcern::BaseActor
    include CurationConcern::BaseActor::DoiAssignable

    def create!
      super
      create_files
    end

    def update!
      super
      create_files
      update_contained_generic_file_visibility
    end
    delegate :visibility_changed?, to: :curation_concern


    protected
    def files
      return @files if defined?(@files)
      @files = [attributes[:files]].flatten.compact
    end

    def create_files
      files.each do |file|
        create_file(file)
      end
    end

    def create_file(file)
      generic_file = GenericFile.new
      generic_file.file = file
      generic_file.batch = curation_concern
      Sufia::GenericFile::Actions.create_metadata(
        generic_file, user, curation_concern.pid
      )
      generic_file.embargo_release_date = curation_concern.embargo_release_date
      generic_file.visibility = visibility
      CurationConcern.attach_file(generic_file, user, file)
    end

    def update_contained_generic_file_visibility
      if visibility_changed?
        curation_concern.generic_files.each do |f|
          f.visibility = visibility
          f.save!
        end
      end
    end
  end
end

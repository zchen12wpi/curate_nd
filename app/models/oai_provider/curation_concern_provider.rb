class OaiProvider < OAI::Provider::Base
  class CurationConcernProvider < OAI::Provider::Model
    OaiRecord = Struct.new(:id, :timestamp, :worktype, :title, :date_uploaded, :creator, :administrative_unit, :abstract, :description, :date_modified)

    # desired fields = [ :title, :creator, :subject, :description, :publisher,
    #             :contributor, :date, :type, :format, :identifier,
    #             :source, :language, :relation, :coverage, :rights,
    #             :administrative_unit, :abstract, :worktype, :id, :date_modified]

    def initialize()
      @limit = nil
      @identifier_field = 'id'
      @timestamp_field = 'timestamp'
    end

    def earliest
      Time.zone.at(0)
    end

    def latest
      Time.current + 1.second
    end

    def find(selector, options = {})
      if selector == :all
        raise NotImplementedError.new
      else
        ActiveFedora::Base.find(selector, cast: true)
        format_for_oai(ActiveFedora::Base.find(selector, cast: true))
      end
    end

    def format_for_oai(record)
      # gem supports fields = [ :title, :creator, :subject, :description, :publisher, # :contributor, :date, :type, :format, :identifier, # :source, :language, :relation, :coverage, :rights]

      # we support fields = [:id, :timestamp, :worktype, :title, :date_uploaded, :creator, :administrative_unit, :abstract, :description, :date_modified]

      if record.respond_to?(:format_for_oai)
        oai_record = record.format_for_oai
      else
        # if work type doesn't respond to oai_record, we send only default values.
        oai_record = OaiRecord.new(
          record.pid, # :id
          record.date_modified.to_time, # :timestamp
          record.human_readable_type, # :worktype
          record.title, # :title
          record.date_uploaded, # :date_uploaded
          record.creator,  # :creator
          record.administrative_unit, # :administrative_unit
          record.respond_to?(:abstract) ? record.abstract : "", # :abstract
          record.respond_to?(:description) ? record.description : "", # :description
          record.date_modified # :date_modified
        )
      end
      oai_record
    end
  end
end

class OaiProvider < OAI::Provider::Base
  repository_name "OaiProvider" # gem throws an error without this value.
  repository_url 'http://localhost/provider'
  record_prefix "oai"
  admin_email ""
  source_model CurationConcernProvider.new
  sample_id "1"
  register_format(CurationConcernProvider::CurateFormat.instance)

  class CurationConcernProvider < OAI::Provider::Model
    def initialize()
      @limit = nil
      @identifier_field = 'identifier'
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
        format_response_terms(ActiveFedora::Base.find(selector, cast: true))
      end
    end

    def format_response_terms(record)
      response_object = {}
      response_object[:identifier] = record.pid
      response_object[:timestamp] = record.date_modified.to_time
      response_object[:worktype] = record.human_readable_type
      record.terms_for_display.each do |term|
        value = record.send(term)
        response_object[term] = value unless value.blank?
      end
      Struct.new(*response_object.keys).new(*response_object.values)
    end
  end

  class CurateFormat < ::OAI::Provider::Metadata::Format
    def initialize
      @prefix = 'oai_dc' # This prefix is important for registered formats
      @schema = 'http://www.openarchives.org/OAI/2.0/oai_dc.xsd'
      @namespace = 'http://www.openarchives.org/OAI/2.0/oai_dc/'
      @element_namespace = 'dc'
      # class created to replace DublinCore in order to override fields included in response.
      @fields = [:identifier, :timestamp, :date_uploaded, :date_modified,
                 :worktype, :title, :subject, :description, :abstract,
                 :creator, :publisher, :contributor,
                 :format, :identifier, :source, :language,
                 :relation, :coverage, :rights, :administrative_unit]
    end

    def header_specification
      {
        'xmlns:oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/",
        'xmlns:dc' => "http://purl.org/dc/elements/1.1/",
        'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
        'xsi:schemaLocation' =>
          %{http://www.openarchives.org/OAI/2.0/oai_dc/
            http://www.openarchives.org/OAI/2.0/oai_dc.xsd}.gsub(/\s+/, ' ')
      }
    end
  end
end

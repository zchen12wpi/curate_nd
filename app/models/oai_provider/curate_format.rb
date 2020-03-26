class OaiProvider < OAI::Provider::Base
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

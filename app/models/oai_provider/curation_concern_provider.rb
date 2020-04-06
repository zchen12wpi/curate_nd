class OaiProvider
  class CurationConcernProvider < OAI::Provider::Model
    def initialize(controller: nil)
      @identifier_field = 'identifier'
      @timestamp_field = 'timestamp'
      @controller = controller
      @limit = 12
    end
    attr_reader :controller, :limit

    def earliest
      Time.zone.at(0)
    end

    def latest
      Time.current + 1.second
    end

    def find(selector, options = {})
      if selector == :all
        response_data = begin
          if options[:resumption_token]
            options = next_set(options[:resumption_token])
          end
          controller.load_data(options.merge(rows: limit))
        end
        wrap_results(response_data, options)
      else
        format_response_terms(ActiveFedora::Base.find(selector, cast: true))
      end
    end

    def next_set(token_string)
      token = OAI::Provider::ResumptionToken.parse(token_string)
      token.to_conditions_hash.merge(page: token.last)
    end

    def wrap_results(response_data, options)
      response = response_data.first
      document_list = response_data.last
      formatted_results = format_response_list(document_list)
      if response_data.first.last_page?
        formatted_results
      else
        OAI::Provider::PartialResult.new(
        formatted_results,
        OAI::Provider::ResumptionToken.new(options.merge(last: response.next_page))
      )
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

    def format_response_list(record_list)
      formatted_list = []
      record_list.map(&:to_model).each do |item|
        formatted_list  << format_response_terms(item)
      end
      formatted_list
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
end

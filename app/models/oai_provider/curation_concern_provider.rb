class OaiProvider < OAI::Provider::Base
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
end

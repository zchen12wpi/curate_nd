module CurationConcern
  module WithJsonMapper
    extend ActiveSupport::Concern

    def as_jsonld
      DatastreamJsonMapper.call(self)
    end
  end
end

module CurationConcern
  module WithJsonMapper
    extend ActiveSupport::Concern

    def as_json_ld
      DatastreamJsonMapper.call(self)
    end
  end
end

module CurationConcern
  module WithJsonMapper
    extend ActiveSupport::Concern

    def to_json_ld
      DatastreamJsonMapper.call(self)
    end
  end
end

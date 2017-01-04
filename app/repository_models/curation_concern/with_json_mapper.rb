module CurationConcern
  module WithJsonMapper
    extend ActiveSupport::Concern

    def as_jsonld
      AsJsonldMapper.call(self)
    end
  end
end

require File.expand_path('../base_actor/doi_assignable', __FILE__)
module CurationConcern
  class DatasetActor < GenericWorkActor
    include CurationConcern::BaseActor::DoiAssignable
  end
end

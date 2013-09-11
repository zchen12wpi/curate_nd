require File.expand_path('../base_actor/doi_assignable', __FILE__)
module CurationConcern
  class ArticleActor < GenericWorkActor
    include CurationConcern::BaseActor::DoiAssignable
  end
end

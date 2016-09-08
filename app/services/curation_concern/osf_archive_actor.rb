module CurationConcern
  class OsfArchiveActor < GenericWorkActor
    def create
      raise NotImplementedError, "This is not implemented as we don't create an OSF Archive via the Actor"
    end
  end
end

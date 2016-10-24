module RDF
  # This is an approximation of a refinement. At present it is perhaps not
  # adequate, but by marking the property as 'contributor#advisor' the
  # URL resolves to the DC Term 'contributor'
  class Ebucore < Vocabulary("http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#")
    property :duration
    property :hasGenre
    property :isDerivedFrom
  end
end

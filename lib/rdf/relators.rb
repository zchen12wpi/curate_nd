# See http://id.loc.gov/vocabulary/relators.rdf
module RDF
  class Relators < Vocabulary("http://id.loc.gov/vocabulary/relators/")
    property :ths #Thesis Advisor
# for EBUCore
    property :aut
    property :cmp
    property :ctb
    property :cnd
    property :ivr
    property :ive
    property :prf
    property :pro
  end
end

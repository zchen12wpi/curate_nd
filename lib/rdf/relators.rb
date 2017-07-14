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
    property :aus
    property :prn
    property :drt
    property :spk
    property :isb # for Catholic Documents; :issued_by
  end
end

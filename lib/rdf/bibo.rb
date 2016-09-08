# See https://github.com/structureddynamics/Bibliographic-Ontology-BIBO
module RDF
  class BIBO < Vocabulary("http://purl.org/ontology/bibo/")
    property :volume
    property :issue
    property :pageStart
    property :pageEnd
    property :numPages
    property :issn
    property :eIssn
    property :isbn
  end
end

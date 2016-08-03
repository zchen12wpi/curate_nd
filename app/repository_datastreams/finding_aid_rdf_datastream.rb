require File.expand_path('../../../lib/rdf/qualified_dc', __FILE__)
class FindingAidRdfDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|

    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable, :displayable
    end

    map.created(in: RDF::DC)

    map.creator(in: RDF::DC) do |index|
      index.as :stored_searchable, :displayable
    end

    map.contributor(in: RDF::DC) do |index|
      index.as :stored_searchable, :displayable
    end

    map.abstract(to: 'abstract', in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.administrative_unit(to: 'creator#administrative_unit', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_searchable, :displayable, :sortable
    end

    map.date_created(:to => "created", :in => RDF::DC) do |index|
      index.type :date
      index.as :stored_searchable, :displayable
    end

    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_searchable, :displayable, :sortable
    end

    map.rights(:in => RDF::DC) do |index|
      index.as :stored_searchable, :displayable, :facetable
    end

    map.identifier({in: RDF::DC})

    map.part(:to => "hasPart", in: RDF::DC)

    map.source(to: 'source', in: RDF::DC) do |index|
      index.as :stored_searchable, :displayable
    end
  end
end

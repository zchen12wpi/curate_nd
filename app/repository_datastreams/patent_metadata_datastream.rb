require File.expand_path('../../../lib/rdf/qualified_dc', __FILE__)
require File.expand_path('../../../lib/rdf/nd', __FILE__)
class PatentMetadataDatastream < ActiveFedora::NtriplesRDFDatastream
  map_predicates do |map|

    map.title(in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.language({in: RDF::DC}) do |index|
      index.as :stored_searchable, :facetable
    end

    map.administrative_unit(to: 'creator#administrative_unit', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.date_issued(to: "issued", in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.description(in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.rights(in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.rights_holder(to: 'rightsHolder', in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.publisher({in: RDF::DC}) do |index|
      index.as :stored_searchable, :displayable, :facetable
    end

    map.date_uploaded(to: "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_searchable, :displayable, :sortable
    end

    map.date_modified(to: "modified", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end

    map.creator(to: 'creator', in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end


    map.patent_number(to: 'identifier#patent', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.other_application(to: 'identifier#other_application', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.application_date(to: "date#application", in: RDF::QualifiedDC) do |index|
      index.as :stored_sortable
    end

    map.prior_publication_date(to: "date#prior_publication", in: RDF::QualifiedDC) do |index|
      index.as :stored_sortable
    end

    map.prior_publication(to: "identifier#prior_publication", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.number_of_claims(to: 'extent#claims', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.us_patent_classification_code(to: 'subject#uspc', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.cooperative_patent_classification_code(to: 'subject#cpc', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.international_patent_classification_code(to: 'subject#ipc', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.creators_from_local_institution(to: "creator#local", in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.patent_office_link(to: 'source', in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.type(in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.relation(:in => RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    map.alephIdentifier(:in =>RDF::ND) do |index|
      index.as :stored_searchable
    end

  end
end

class DocumentDatastream < GenericWorkRdfDatastream
  map_predicates do |map|

    # @book
    map.alternate_title(to: 'alternative', in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.author(to: 'creator#author', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    # @book
    map.creator(to: 'creator', in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    # @book
    map.coauthor(to: 'contributor#author', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable, :facetable
    end

    # @book
    map.contributor(to: 'contributor', in: RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end

    # @book
    map.editor(to: 'creator#editor', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.contributing_editor(to: 'contributor#editor', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.artist(to: 'creator#artist', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.contributing_artist(to: 'contributor#artist', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.illustrator(to: 'creator#illustrator', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.contributing_illustrator(to: 'contributor#illustrator', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.photographer(to: 'creator#photographer', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.contributing_photographer(to: 'contributor#photographer', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.copyright_date(to: 'dateCopyrighted', in: RDF::DC)

    # @book
    map.table_of_contents(to: 'description#table_of_contents', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.extent(in: RDF::DC)

    # @book
    map.isbn(to: 'identifier#isbn', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.local_identifier(to: 'identifier#local', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    # @book
    map.publication_date(to: 'issued', in: RDF::DC)

    # @book
    map.edition(to: 'isVersionOf#edition', in: RDF::QualifiedDC)

    # @book
    map.lc_subject(to: 'subject#lcsh', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.abstract(to: 'abstract', in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.type(in: RDF::DC) do |index|
      index.type :text
      index.as :stored_searchable
    end

    map.repository_name(to: 'contributor#repository', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.collection_name(to: 'relation#ispartof', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.temporal_coverage(to: 'temporal', in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.spatial_coverage(to: 'spatial', in: RDF::DC) do |index|
      index.as :stored_searchable
    end

    map.contributor_institution(to: 'contributor#institution', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.permission(to: 'rights#permissions', in: RDF::QualifiedDC)

    map.size(to: 'format#extent', in: RDF::QualifiedDC)

    map.format(to: 'format#mimetype', in: RDF::QualifiedDC)

    map.recommended_citation(to: 'bibliographicCitation', in: RDF::DC)

    map.identifier(to: 'identifier#doi', in: RDF::QualifiedDC) do |index|
      index.as :stored_searchable
    end

    map.doi(to: 'identifier#doi', in: RDF::QualifiedDC)

    map.date_uploaded(to: 'dateSubmitted', in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end

    map.date_modified(to: 'modified', in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end

    map.relation(:in => RDF::DC) do |index|
      index.as :stored_searchable, :facetable
    end
  end
end

require 'json'
require 'rexml/document'
require 'rdf/ntriples'
require 'rdf/rdfxml'

# This class is responsible for generating a JSON-LD Hash from an ActiveFedora::Base object
#
# Addresses https://jira.library.nd.edu/browse/DLTP-751
# http://json-ld.org/spec/latest/json-ld/#named-graphs
#
# @see AsJsonldMapper.call for further details
class AsJsonldMapper
  # @api public
  # @param curation_concern [ActiveFedora::Base] A work that conforms to implicit Curate "Model" concept (e.g. CurationConcern::Model)
  # @param curation_concern [ActiveFedora::Base]
  # @return [Hash] A JSON-LD hash that is representative of the given curation concern
  def self.call(curation_concern, **keywords)
    new(curation_concern, **keywords).call
  end

  # The keys need to be symbols to prevent the RDF library from balking.
  CONTEXT = {
      'und'.to_sym => File.join(Rails.configuration.application_root_url, 'show/'),
      'bibo'.to_sym => 'http://purl.org/ontology/bibo/',
      'dc'.to_sym => 'http://purl.org/dc/terms/',
      'ebucore'.to_sym => 'http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#',
      'foaf'.to_sym => 'http://xmlns.com/foaf/0.1/',
      'mrel'.to_sym => 'http://id.loc.gov/vocabulary/relators/',
      'nd'.to_sym => 'https://library.nd.edu/ns/terms/',
      'rdfs'.to_sym => 'http://www.w3.org/2000/01/rdf-schema#',
      'vracore'.to_sym => 'http://purl.org/vra/',
      'frels'.to_sym => 'info:fedora/fedora-system:def/relations-external#',
      'ms'.to_sym => 'http://www.ndltd.org/standards/metadata/etdms/1.1/',
      "fedora-model".to_sym => "info:fedora/fedora-system:def/model#",
      "hydra".to_sym => "http://projecthydra.org/ns/relations#",
      "hasModel".to_sym => {"@id" => "fedora-model:hasModel", "@type" => "@id" },
      "hasEditor".to_sym => {"@id" => "hydra:hasEditor", "@type" => "@id" },
      "hasEditorGroup".to_sym => {"@id" => "hydra:hasEditorGroup", "@type" => "@id" },
      "isPartOf".to_sym => {"@id" => "frels:isPartOf", "@type" => "@id" },
      "isMemberOfCollection".to_sym => {"@id" => "frels:isMemberOfCollection", "@type" => "@id" },
      "isEditorOf".to_sym => {"@id" => "hydra:isEditorOf", "@type" => "@id" },
      "hasMember".to_sym => {"@id" => "frels:hasMember", "@type" => "@id" },
      "previousVersion".to_sym => "http://purl.org/pav/previousVersion"
  }

  DEFAULT_ATTRIBUTES = {
      'read' => "nd:accessRead".freeze,
      'read-groups' => "nd:accessReadGroup".freeze,
      'edit' => "nd:accessEdit".freeze,
      'edit-groups' => "nd:accessEditGroup".freeze,
      'embargo' => "nd:accessEmbargoDate".freeze,
      'depositor' => "nd:depositor".freeze,
      'owner' => "nd:owner".freeze,
      'representative' => "nd:representativeFile".freeze
  }

  AF_MODEL_KEY = "nd:afmodel".freeze

  #Additional metadata fields

  BENDO_KEY = "nd:bendoitem".freeze
  BENDO_CONTENT_KEY = "nd:bendocontent".freeze
  FILENAME_KEY = "nd:filename".freeze
  CONTENT_KEY = "nd:content".freeze
  THUMBNAIL_KEY = "nd:thumbnail".freeze
  CONTENT_MIME_TYPE_KEY = "nd:mimetype".freeze
  CHARACTERIZATION_KEY = "nd:characterization".freeze

  def initialize(curation_concern, attribute_map: default_attribute_map, graph: default_graph)
    self.curation_concern = curation_concern
    self.attribute_map = attribute_map
    self.graph = graph
    self.curation_concern_uri_term = RDF::URI.new("info:fedora/#{curation_concern.pid}")
  end

  def call
    process_datastreams
    json_document = strip_info_fedora_prefix(generate_json_output)
    JSON.parse(json_document)
  end

  private

  def default_graph
    RDF::Graph.new
  end

  attr_accessor :curation_concern, :attribute_map, :graph, :curation_concern_uri_term

  def process_datastreams
    curation_concern.datastreams.each do |dsname, ds|
      next if dsname == 'DC'
      method_key = "process_#{dsname.gsub('-', '')}".to_sym
      if respond_to?(method_key, true)
        self.send(method_key, ds)
      else
        Rails.logger.error("#{curation_concern.pid}: unknown datastream #{dsname}")
      end
    end
  end

  def generate_json_output
    JSON::LD::Writer.buffer(prefixes: CONTEXT) do |writer|
      graph.each_statement do |statement|
        writer << statement
      end
    end
  end

  def strip_info_fedora_prefix(document)
    document.gsub(/info:fedora\/und:/, 'und:')
  end

  def process_descMetadata(ds)
    data = ds.datastream_content.force_encoding('utf-8')

    # Why the graph? Without the graph, the generate_json_output does not generate the correct
    # graph data. This was the easiest mechanism for ensuring what appears to be a more proper
    # construction of the resulting graph the same output
    graph.from_ntriples(data, format: :ntriples)
  end

  def process_RELSEXT(ds)
    data = ds.datastream_content.force_encoding('utf-8')
    # I would love to be able to use `graph.from_rdfxml(data)`, however, we need to coerce one of the nodes into the nd:afmodel
    # Thus I cannot accept all of the statements outright
    # graph.from_rdfxml(data)
    # return
    reader = RDF::RDFXML::Reader.new(data)
    reader.each_statement do |statement|
      if statement.predicate.to_s =~ /#hasModel$/i
        object = statement.object.to_s.sub("info:fedora/afmodel:", '')
        graph << RDF::Statement.new(curation_concern_uri_term, 'nd:afmodel', object)
      else
        graph << statement
      end
    end
  end

  def process_rightsMetadata(ds)
    # rights is an XML document
    # the access array may have read or edit elements
    # each of these elements may contain group or person elements
    xml_doc = REXML::Document.new(ds.datastream_content)
    rights = {}
    embargo_date_array = []
    root = xml_doc.root

    %w(read edit).each do |access|
      this_access = root.elements["//access[@type=\'#{access}\']"]

      next if this_access.nil?

      unless this_access.elements['machine'].elements['group'].nil?
        group_array = []
        this_access.elements['machine'].elements['group'].each do |this_group|
          group_array << this_group.to_s
        end
        rights[extract_context_name_for("#{access}-groups")] = group_array
      end

      next if this_access.elements['machine'].elements['person'].nil?
      person_array = []

      this_access.elements['machine'].elements['person'].each do |this_person|
        person_array << this_person.to_s
      end
      rights[extract_context_name_for(access.to_s)] = person_array
    end

    unless root.elements['embargo'].elements['machine'].elements['date'].nil?
      root.elements['embargo'].elements['machine'].elements['date'].each do |this_embargo|
        embargo_date_array << this_embargo
      end
      rights[extract_context_name_for("embargo")] = embargo_date_array unless embargo_date_array.blank?
    end

    # Build the rights
    rights.each do |key, values|
      Array.wrap(values).each do |value|
        graph << RDF::Statement.new(curation_concern_uri_term, key, value)
      end
    end
  end

  def process_properties(ds)
    xml_doc = REXML::Document.new(ds.datastream_content)
    root = xml_doc.root
    root.each_element do |element|
      predicate = extract_context_name_for(element.name)
      if element.name.eql?('representative')
        statement_object = RDF::URI.new(element.text.to_s)
      else
        statement_object = element.text.to_s
      end
      graph << RDF::Statement.new(curation_concern_uri_term, predicate, statement_object)
    end
  end

  CHARACTERIZATION_PREDICATE_NAME = "nd:characterization".freeze
  def process_characterization(ds)
    return unless ds.datastream_content.present?
    graph << RDF::Statement.new(curation_concern_uri_term, CHARACTERIZATION_PREDICATE_NAME, ds.datastream_content)
  end

  BENDO_PREDICATE_NAME = "nd:bendoitem".freeze
  def process_bendoitem(ds)
    return unless ds.datastream_content.present?
    graph << RDF::Statement.new(curation_concern_uri_term, BENDO_PREDICATE_NAME, ds.datastream_content)
  end

  THUMBNAIL_PREDICATE_NAME = "nd:thumbnail".freeze
  def process_thumbnail(ds)
    thumbnail_url = File.join(Rails.configuration.application_root_url, "/downloads/",  curation_concern.noid, "/thumbnail")
    graph << RDF::Statement.new(curation_concern_uri_term, THUMBNAIL_PREDICATE_NAME, RDF::URI.new(thumbnail_url))
  end

  BENDO_CONTENT_PREDICATE_NAME = "nd:bendocontent".freeze
  FILENAME_PREDICATE_NAME = "nd:filename".freeze
  CONTENT_PREDICATE_NAME = "nd:content".freeze
  CONTENT_MIME_TYPE_PREDICATE_NAME = "nd:mimetype".freeze
  def process_content(ds)
    content_url = File.join(Rails.configuration.application_root_url, "/downloads/", curation_concern.noid)
    graph << RDF::Statement.new(curation_concern_uri_term, FILENAME_PREDICATE_NAME, ds.label)
    graph << RDF::Statement.new(curation_concern_uri_term, CONTENT_PREDICATE_NAME, content_url)
    graph << RDF::Statement.new(curation_concern_uri_term, CONTENT_MIME_TYPE_PREDICATE_NAME, ds.mimeType)
    bendo_url = bendo_location(ds.datastream_content)
    graph << RDF::Statement.new(curation_concern_uri_term, BENDO_CONTENT_PREDICATE_NAME, bendo_url) unless bendo_url.blank?
  end

  def extract_context_name_for(attribute)
    attribute_map.fetch(attribute, attribute)
  end

  def default_attribute_map
    DEFAULT_ATTRIBUTES
  end

  def bendo_location(content)
    location = ""
    bendo_datastream = Bendo::DatastreamPresenter.new(datastream: content)
    location = bendo_datastream.location if bendo_datastream.valid?
    return location
  end
end

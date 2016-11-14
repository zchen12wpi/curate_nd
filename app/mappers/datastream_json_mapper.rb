require 'json'
require 'rexml/document'
require 'rdf/ntriples'
require 'rdf/rdfxml'
# Mapper to map datastreams to JSON format
class DatastreamJsonMapper
  CONTEXT = {
      'bibo' => 'http://purl.org/ontology/bibo/',
      'dc' => 'http://purl.org/dc/terms/',
      'ebucore' => 'http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#',
      'foaf' => 'http://xmlns.com/foaf/0.1/',
      'mrel' => 'http://id.loc.gov/vocabulary/relators/',
      'nd' => 'https://library.nd.edu/ns/terms/',
      'rdfs' => 'http://www.w3.org/2000/01/rdf-schema#',
      'vracore' => 'http://purl.org/vra/',
      'frels' => 'info:fedora/fedora-system:def/relations-external#',
      'ms' => 'http://www.ndltd.org/standards/metadata/etdms/1.1/',
      "fedora-model" => "info:fedora/fedora-system:def/model#",
      "hydra" => "http://projecthydra.org/ns/relations#",
      "hasModel" => {"@id" => "fedora-model:hasModel", "@type" => "@id" },
      "hasEditor" => {"@id" => "hydra:hasEditor", "@type" => "@id" },
      "hasEditorGroup" => {"@id" => "hydra:hasEditorGroup", "@type" => "@id" },
      "isPartOf" => {"@id" => "frels:isPartOf", "@type" => "@id" },
      "isMemberOfCollection" => {"@id" => "frels:isMemberOfCollection", "@type" => "@id" },
      "isEditorOf" => {"@id" => "hydra:isEditorOf", "@type" => "@id" },
      "hasMember" => {"@id" => "frels:hasMember", "@type" => "@id" },
      "previousVersion" => "http://purl.org/pav/previousVersion"
  }.freeze

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

  CURATE_DOWNLOAD_URL = "https://curate.nd.edu/downloads"

  def self.call(curation_concern, **keywords)
    new(curation_concern, **keywords).call
  end

  def initialize(curation_concern,attribute_map: default_attribute_map)
    self.curation_concern = curation_concern
    self.attribute_map = attribute_map
    self.fedora_info = {}
  end

  def call
    process_datastreams
    return format_output
  end

  attr_accessor :curation_concern, :attribute_map, :fedora_info, :metadata

  private

  def process_datastreams
    curation_concern.datastreams.each do |dsname, ds|
      next if dsname == 'DC'
      method_key = "process_#{dsname.gsub('-', '')}".to_sym
      if respond_to?(method_key, true)
        self.send(method_key, ds)
      else
        puts "Error: -- Unknown Datastream #{dsname}."
      end
    end
  end

  def process_descMetadata(ds)
    # desMetadata is encoded in ntriples, convert to JSON-LD using our special context
    graph = RDF::Graph.new
    data = ds.datastream_content
    metadata_hash = nil
    # force utf-8 encoding. fedora does not store the encoding, so it defaults to ASCII-8BIT
    # see https://github.com/ruby-rdf/rdf/issues/142
    data.force_encoding('utf-8')
    graph.from_ntriples(data, format: :ntriples)
    JSON::LD::API.fromRdf(graph) do |expanded|
      metadata_hash = JSON::LD::API.compact(expanded, CONTEXT)
    end
    strip_info_fedora(metadata_hash)
    fedora_info['metadata'] = metadata_hash
  end

  def process_RELSEXT(ds)
    # RELS-EXT is RDF-XML - parse it
    ctx = CONTEXT.dup
    ctx.delete('@base') # @base causes problems when converting TO json-ld (it is = "info:/fedora") but info is not a namespace
    graph = RDF::Graph.new
    graph.from_rdfxml(ds.datastream_content)
    rels_ext_hash = nil
    JSON::LD::API.fromRdf(graph) do |expanded|
      rels_ext_hash = JSON::LD::API.compact(expanded, ctx)
    end
    # now strip the info:fedora/ prefix from the URIs
    strip_info_fedora(rels_ext_hash)
    # rename hasModel Key
    model_name = rels_ext_hash.fetch('hasModel').sub('afmodel:', '')
    rels_ext_hash[AF_MODEL_KEY]=model_name
    rels_ext_hash.delete('hasModel')
    fedora_info['rels-ext'] = rels_ext_hash
  end

  def process_rightsMetadata(ds)
    # rights is an XML document
    # the access array may have read or edit elements
    # each of these elements may contain group or person elements
    xml_doc = REXML::Document.new(ds.datastream_content)
    rights_array = {}
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
        rights_array[extract_name_for("#{access}-groups")] = group_array
      end

      next if this_access.elements['machine'].elements['person'].nil?
      person_array = []

      this_access.elements['machine'].elements['person'].each do |this_person|
        person_array << this_person.to_s
      end
      rights_array[extract_name_for(access.to_s)] = person_array
    end

    unless root.elements['embargo'].elements['machine'].elements['date'].nil?
      root.elements['embargo'].elements['machine'].elements['date'].each do |this_embargo|
        embargo_date_array << this_embargo
      end
      rights_array[extract_name_for("embargo")] = embargo_date_array unless embargo_date_array.blank?
    end
    fedora_info['rights'] = rights_array
  end

  def process_characterization(ds)
    fedora_info['characterization'] = {CHARACTERIZATION_KEY => ds.datastream_content}
  end

  def process_properties(ds)
    properties_hash = {}
    xml_doc = REXML::Document.new(ds.datastream_content)
    root = xml_doc.root
    root.each_element do |element|
      text = element.name.eql?('representative') ? format_text(element.get_text) : element.text.to_s
      properties_hash[extract_name_for(element.name)] = text
    end
    fedora_info['properties'] = properties_hash
  end

  def process_content(ds)
    content_properties_hash = {}
    content_ds = ds.datastream_content
    bendo_url = bendo_location(content_ds)
    content_url = CURATE_DOWNLOAD_URL + "/" + strip_namespace(curation_concern.id)
    content_properties_hash[FILENAME_KEY] = ds.label
    content_properties_hash[CONTENT_KEY] = content_url
    content_properties_hash[CONTENT_MIME_TYPE_KEY] =  ds.mimeType
    content_properties_hash[BENDO_CONTENT_KEY] = bendo_url unless bendo_url.blank?
    fedora_info['content'] = content_properties_hash
  end

  def process_bendoitem(ds)
    fedora_info['bendo'] = {BENDO_KEY => ds.datastream_content}
  end

  def process_thumbnail(ds)
    thumbnail_url = CURATE_DOWNLOAD_URL + "/" + strip_namespace(curation_concern.id) + "/thumbnail"
    fedora_info['thumbnail'] = {THUMBNAIL_KEY => format_text(thumbnail_url)}
  end

  def strip_namespace(pid)
    String(pid).split(":").last
  end

  def strip_info_fedora(rels_ext)
    rels_ext.each do |relation, targets|
      next if relation == '@context'
      if targets.is_a?(Hash)
        strip_info_fedora(targets)
        next
      end
      targets = [targets] if targets.is_a?(String)
      targets.map! do |target|
        if target.is_a?(Hash)
          strip_info_fedora(target)
        else
          target.sub('info:fedora/', '')
        end
      end
      # some single strings cannot be arrays in json-ld, so convert back
      # this shouldn't cause any problems with items that began as arrays
      targets = targets[0] if targets.length == 1
      rels_ext[relation] = targets
    end
  end

  def format_text(text)
    return {"@id" => text.to_s}
  end

  def format_output
    unified_datastreams = {}
    fedora_info.each do |key,value|
      value.each do |attribute_key, attribute_value|
        unified_datastreams[attribute_key]=attribute_value unless attribute_value.blank?
      end
    end
    return unified_datastreams
  end

  def bendo_location(content)
    location = ""
    bendo_datastream = Bendo::DatastreamPresenter.new(datastream: content)
    location = bendo_datastream.location if bendo_datastream.valid?
    return location
  end

  def extract_name_for(attribute)
    attribute_map.fetch(attribute, attribute)
  end

  def default_attribute_map
    DEFAULT_ATTRIBUTES
  end
end

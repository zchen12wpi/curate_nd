module Curate
  # Mapper to map datastreams to JSON format
  class RepositoryModelMapper
    CONTENT_MODEL_NAME = 'Article'.freeze
    NAMESPACE = 'und:'.freeze
    BATCH_USER = 'curate_batch_user'.freeze
    TERM_URI = {
        und: "https://curate.nd.edu/show/",
        nd: "https://library.nd.edu/ns/terms/",
        dc: "http://purl.org/dc/terms/",
        foaf: "http://xmlns.com/foaf/0.1/",
        rdfs: "http://www.w3.org/2000/01/rdf-schema#",
        frels: "info:fedora/fedora-system:def/relations-external#",
        ms: 'http://www.ndltd.org/standards/metadata/etdms/1.1/',
        ths: 'http://id.loc.gov/vocabulary/relators/',
        "dc:dateSubmitted" => { "@type" => "http://www.w3.org/2001/XMLSchema#date" },
        "dc:dateSubmitted" => {"@type" => "http://www.w3.org/2001/XMLSchema#date" },
        "dc:created" => {"@type" => "http://www.w3.org/2001/XMLSchema#date" },
        "dc:modified" => {"@type" => "http://www.w3.org/2001/XMLSchema#date" },
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

    EXCLUDED_PREDICATES = [ActiveFedora::Predicates.find_graph_predicate(:has_model)].freeze

    DEFAULT_ATTRIBUTES = {
        creator: "dc:creator",
        title: "dc:title",
        alternate_title: "dc:title#alternate",
        subject: "dc:subject",
        abstract: "dc:description#abstract",
        country: "dc:publisher#country",
        advisor: "ths:relators",
        contributor: "dc:contributor",
        contributor_role: "ms:role",
        date: "dc:date",
        date_created: "dc:date#created",
        date_uploaded: "dc:dateSubmitted",
        date_modified: "dc:modified",
        language: "dc:language",
        copyright: "dc:rights",
        note: "dc:description#note",
        publisher: "dc:publisher",
        temporal_coverage: "dc:coverage#temporal",
        spatial_coverage: "dc:coverage#spatial",
        identifier: "dc:identifier#doi",
        urn: "dc:identifier#other",
        defense_date: "dc:date",
        date_approved: "dc:date#approved",
        administrative_unit: "dc:creator#administrative_unit",
        affiliation: "dc:creator#affiliation",
        rights: "dc:rights",
        identifier:"dc:identifier",
        urn:"dc:identifier#other",
        doi:"dc:identifier#doi",
        format:"dc:format#mimetype",
        relation:"dc:relation",
        alephIdentifier:"dc:alephIdentifier"
    }.freeze

    AF_MODEL_KEY = "nd:afmodel".freeze

    READ_USER_KEY = "nd:accessRead".freeze
    READ_GROUP_KEY = "nd:accessReadGroup".freeze
    EDIT_USER_KEY = "nd:accessEdit".freeze
    EDIT_GROUP_KEY = "nd:accessEditGroup".freeze
    EMBARGO_KEY = "nd:accessEmbargoDate".freeze

    #Additional metadata fields
    DEPOSITOR_KEY = "nd:depositor".freeze
    OWNER_KEY = "nd:owner".freeze
    REPRESENTATIVE_FILE_KEY = "nd:representativeFile".freeze
    BENDO_KEY = "nd:bendoitem".freeze
    BENDO_CONTENT_KEY = "nd:bendocontent".freeze
    FILENAME_KEY = "nd:filename".freeze
    CONTENT_KEY = "nd:content".freeze
    THUMBNAIL_KEY = "nd:thumbnail".freeze
    CONTENT_MIME_TYPE_KEY = "nd:mimetype".freeze
    CHARACTERIZATION_KEY = "nd:characterization".freeze

    CURATE_URL = "https://curate.nd.edu/downloads"


    def self.call(curation_concern, **keywords)
      new(curation_concern, **keywords).call
    end

    def initialize(curation_concern,attribute_map: default_attribute_map)
      self.curation_concern = curation_concern
      self.attribute_map = attribute_map
    end

    def call
      build_json
    end

    private

    attr_accessor :curation_concern, :attribute_map

    def build_json
      Jbuilder.encode do |json|
        gather_context(json)
        process_datastreams(json)
      end
    end

    def process_datastreams(json)
      json.set!("@id", curation_concern.id)
      gather_metadata(json) if curation_concern.datastreams.has_key?('descMetadata')
      gather_relation(json) if curation_concern.datastreams.has_key?('RELS-EXT')
      gather_properties(json) if curation_concern.datastreams.has_key?('properties')
      gather_rights(json) if curation_concern.datastreams.has_key?('rightsMetadata')
      gather_content_metadata(json) if curation_concern.datastreams.has_key?('content')
      gather_characterization_details(json) if curation_concern.datastreams.has_key?('characterization')
    end

    def escape_namespace(pid)
      pid.split(":").last
    end

    def attributes
      attributes = {}
      curation_concern.class.registered_attribute_names.each_with_object({}) do |name, hash|
        attributes[name] = curation_concern.public_send(name)
      end
      attributes
    end

    def gather_context(json)
      json.set!("@context", TERM_URI)
    end

    def gather_metadata(json)
      attributes.each do |key, value|
        json.set!(extract_name_for(key), value) unless value.blank?
      end
    end

    def gather_relation(json)
      curation_concern.relationships.each do |statement|
        pid = statement.object.value
        json.set!(statement.predicate.fragment, pid.gsub("info:fedora/","")) unless EXCLUDED_PREDICATES.include?statement.predicate
      end
    end

    def gather_properties(json)
      json.set!(DEPOSITOR_KEY, curation_concern.depositor) if curation_concern.depositor.present?
      json.set!(OWNER_KEY, curation_concern.owner) if curation_concern.owner.present?
      if curation_concern.representative.present?
        representative_pid = curation_concern.representative
        thumnail_url = CURATE_URL + "/" + escape_namespace(representative_pid) + "/thumnail"
        json.set! REPRESENTATIVE_FILE_KEY.to_sym do
          json.set!('@id', representative_pid )
        end
        json.set!(THUMBNAIL_KEY, thumnail_url  )
      end
    end

    def gather_rights(json)
      curation_concern.read_users.each do |user|
        json.set!(READ_USER_KEY, user)
      end
      curation_concern.read_groups.each do |group|
        json.set!(READ_GROUP_KEY, group)
      end
      curation_concern.edit_users.each do |user|
        json.set!(EDIT_USER_KEY, user)
      end
      curation_concern.edit_groups.each do |group|
        json.set!(EDIT_GROUP_KEY, group)
      end
      json.set!(EMBARGO_KEY, curation_concern.embargo_release_date) if curation_concern.visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO
    end

    def gather_bendo_item(json)
      json.set!(BENDO_KEY, curation_concern.datastreams.fetch('bendo-item').content)
    end

    def gather_content_metadata(json)
      content_ds = curation_concern.datastreams.fetch('content')
      bendo_url = bendo_location(content_ds)
      content_url = CURATE_URL + "/" + curation_concern.id
      json.set!(FILENAME_KEY, content_ds.label)
      json.set!(CONTENT_KEY, content_url)
      json.set!(CONTENT_MIME_TYPE_KEY, content_ds.mime_type)
      json.set!(BENDO_CONTENT_KEY, bendo_url) unless bendo_url.blank?
      gather_thumbnail_details(json)
      gather_characterization_details(json)
    end

    def gather_thumbnail_details(json)
      thumnail_url = CURATE_URL + "/" + curation_concern.id + "/thumnail"
      #TODO check if this need to validated or not
      if curation_concern.datastreams.has_key?('thumbnail')
        json.set!(THUMBNAIL_KEY, thumnail_url) do
          json.set!("@id", thumnail_url)
        end
      end
    end

    def gather_characterization_details(json)
      json.set!(CHARACTERIZATION_KEY, curation_concern.datastreams.fetch('characterization'))
    end

    def bendo_location(content)
      location = ""
      bendo_datastream = Bendo::DatastreamPresenter.new(datastream: content)
      location = bendo_datastream.location if bendo_datastream.valid?
      return location
    end

    def extract_name_for(attribute)
      attribute_map.fetch(attribute.to_sym, attribute)
    end

    def default_attribute_map
      DEFAULT_ATTRIBUTES
    end
  end
end


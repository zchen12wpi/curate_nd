class Document < GenericWork

  has_metadata 'descMetadata', type: DocumentDatastream

  self.human_readable_short_description = 'Deposit any text-based document (other than an article).'

  self.indefinite_article = 'an'
  self.contributor_label = 'Author'

  DOCUMENT_TYPES = [
    'Book', 'Book Chapter', 'Brochure', 'Document', 'Letter', 'Manuscript', 'Newsletter', 'OpenCourseWare', 'Pamphlet',
    'Presentation', 'Press Release', 'Report', 'Software', 'White Paper', 'Video'
  ].freeze

  def self.valid_types
    DOCUMENT_TYPES
  end

  def human_readable_type
    self.type.present? ? type.titleize :  self.class.human_readable_type
  end

  # @book attributes
  attribute :alternate_title,            datastream: :descMetadata, multiple: true
  attribute :author,                     datastream: :descMetadata, multiple: true
  attribute :coauthor,                   datastream: :descMetadata, multiple: true
  attribute :contributor,                datastream: :descMetadata, multiple: true
  attribute :editor,                     datastream: :descMetadata, multiple: true
  attribute :contributing_editor,        datastream: :descMetadata, multiple: true
  attribute :artist,                     datastream: :descMetadata, multiple: true
  attribute :contributing_artist,        datastream: :descMetadata, multiple: true
  attribute :illustrator,                datastream: :descMetadata, multiple: true
  attribute :contributing_illustrator,   datastream: :descMetadata, multiple: true
  attribute :photographer,               datastream: :descMetadata, multiple: true
  attribute :contributing_photographer,  datastream: :descMetadata, multiple: true
  attribute :copyright_date,             datastream: :descMetadata, multiple: false
  attribute :table_of_contents,          datastream: :descMetadata, multiple: false
  attribute :extent,                     datastream: :descMetadata, multiple: true
  attribute :isbn,                       datastream: :descMetadata, multiple: true
  attribute :local_identifier,           datastream: :descMetadata, multiple: true
  attribute :publication_date,           datastream: :descMetadata, multiple: false
  attribute :edition,                    datastream: :descMetadata, multiple: false
  attribute :lc_subject,                 datastream: :descMetadata, multiple: true

  attribute :type, datastream: :descMetadata,
    multiple: false,
    validates: { inclusion: { in: Document.valid_types,
                              allow_blank: true } }
  attribute :affiliation,datastream: :descMetadata, hint: 'Creator’s Affiliation to the Institution.', multiple: false
  attribute :organization,
            datastream: :descMetadata, multiple: true,
            label: 'School & Department',
            hint: 'School and Department that creator belong to.'
  attribute :date_created,               datastream: :descMetadata, multiple: false, default: lambda { Date.today.to_s('%Y-%m-%d') }
  attribute :date_uploaded,              datastream: :descMetadata, multiple: false
  attribute :date_modified,              datastream: :descMetadata, multiple: false
  attribute :alternate_title,            datastream: :descMetadata, multiple: true
  attribute :creator,                    datastream: :descMetadata, multiple: true
  attribute :contributor_institution,    datastream: :descMetadata, multiple: true
  attribute :abstract,                   datastream: :descMetadata, multiple: false
  attribute :repository_name,            datastream: :descMetadata, multiple: true
  attribute :collection_name,            datastream: :descMetadata, multiple: true
  attribute :temporal_coverage,          datastream: :descMetadata, multiple: true
  attribute :spatial_coverage,           datastream: :descMetadata, multiple: true
  attribute :permission,                 datastream: :descMetadata, multiple: false
  attribute :size,                       datastream: :descMetadata, multiple: true
  attribute :format,                     datastream: :descMetadata, multiple: false
  attribute :recommended_citation,       datastream: :descMetadata, multiple: true
  attribute :identifier,                 datastream: :descMetadata, multiple: false
  attribute :doi,                        datastream: :descMetadata, multiple: false
end

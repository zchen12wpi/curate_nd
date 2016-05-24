class Patent < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
  include CurationConcern::WithRecordEditors
  include CurationConcern::WithRecordViewers

  include ActiveFedora::RegisteredAttributes

  has_metadata "descMetadata", type: PatentMetadataDatastream


  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Deposit a patent."

  attribute :title, datastream: :descMetadata, multiple: false,
            label: "Title of the Patent",
            validates: { presence: { message: 'Your patent must have a title.' } }
  attribute :creator, datastream: :descMetadata, multiple: true,
            label: "Inventor",
            hint:"An entity listed on the patent as an inventor."
  attribute :administrative_unit, datastream: :descMetadata, multiple: true,
            label: "Departments and Units",
            hint: "Departments and Units that creator belong to."
  attribute :description, datastream: :descMetadata, multiple: false,
            label: "Description of patent, may contain abstract.",
            validates: { presence: { message: 'The Patent must have an description.' } }
  attribute :patent_number,
            datastream: :descMetadata, multiple: false,
            validates: { presence: { message: 'Your Patent must have an patent_number.' } },
            hint: "The patent number for this resource. Probably refers to the USPTO but not restricted to US patents."
  attribute :patent_office_link, datastream: :descMetadata, multiple: false,label: "USPTO Link",
            hint: "Link to the patent at the USPTO website (or other patent office websites)."
  attribute :other_application, datastream: :descMetadata, multiple: false
  attribute :application_date, multiple: false,
            hint: "The date of the initial submission of the application for this patent."
  attribute :prior_publication_date, datastream: :descMetadata, multiple: true,
            label: "Prior Publication Date"
  attribute :prior_publication, datastream: :descMetadata,multiple: true,
            label: "Prior Publication Number"
  attribute :number_of_claims, datastream: :descMetadata, multiple: false,
            label: "Claims" ,
            hint: "The number of claims in this patent. Usually an integer, but has type string to handle any possible special cases."
  attribute :us_patent_classification_code, datastream: :descMetadata, multiple: true,
            label: "Classification (US Patent)" ,
             hint: "US Patent Classification codes."
  attribute :cooperative_patent_classification_code, datastream: :descMetadata, multiple: true,
            label: "Classification (CPC)" ,
            hint: "Cooperative Patent Classification codes"
  attribute :international_patent_classification_code, datastream: :descMetadata, multiple: true,
            label: "Classification (IPC)" ,
            hint: "International Patent Classification codes"
  attribute :creators_from_local_institution, datastream: :descMetadata, multiple: true,
            hint: "Inventors who are (or were) associated with the local institution. People are to be listed here in addition to being listed in inventor."
  attribute :prior_publication, datastream: :descMetadata, multiple: false, label: "Prior Publication Number"
  attribute :date_issued, datastream: :descMetadata, multiple: false,
            hint: "Date the patent was issued."
  attribute :date_modified, datastream: :descMetadata, multiple: false
  attribute :date_uploaded, datastream: :descMetadata, multiple: false,
            label: "Date Added"
  attribute :language, datastream: :descMetadata, multiple: true,
            hint: "What is the language(s) in which you wrote your work?",
            default: ['English'],
            validates: { presence: { message: 'You patent must have a language'}}
  attribute :publisher, datastream: :descMetadata, multiple: true
  attribute :rights, datastream: :descMetadata, multiple: false,
            default: "All rights reserved",
            validates: { presence: { message: 'You must select a license for your work.' } }
  attribute :rights_holder, datastream: :descMetadata, multiple: true,
            label: "Assignee"
  attribute :files,
            multiple: true, form: {as: :file}, label: "Upload Files",
            hint: "CTRL-Click (Windows) or CMD-Click (Mac) to select multiple files."

end

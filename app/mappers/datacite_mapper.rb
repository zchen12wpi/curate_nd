class DataciteMapper
  def self.call(curation_concern)
    {
      status: "public",
      profile: "datacite",
      target: Curate.permanent_url_for(curation_concern),
      datacite_resourcetype: "CreativeWork",
      datacite_resourcetypegeneral: "Other",
      datacite_creator: Array.wrap(curation_concern.creator).collect(&:to_s).join(", "),
      datacite_title: curation_concern.title,
      datacite_publisher: (I18n.t('sufia.institution_name')),
      datacite_publicationyear: curation_concern.date_uploaded.year,
    }
  end
end

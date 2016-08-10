# Register and configure remote identifiers for persisted objects
Hydra::RemoteIdentifier.configure do |config|
  doi_credentials = {
    username: ENV.fetch('DOI_USERNAME'),
    password: ENV.fetch('DOI_PASSWORD'),
    shoulder: ENV.fetch('DOI_SHOULDER'),
    url: ENV.fetch('DOI_URL')
  }
  config.remote_service(:doi, doi_credentials) do |doi|
    doi.register(SeniorThesis) do |map|
      map.target {|obj| Curate.permanent_url_for(obj) }
      map.creator :creator
      map.title :title
      map.publisher { (I18n.t('sufia.institution_name')) }
      map.publicationyear {|o| o.date_uploaded.year }
      map.set_identifier { |o,value| o.identifier = value }
    end

    doi.register(Dataset, Image, Document, Article, Etd) do |map|
      map.target {|obj| Curate.permanent_url_for(obj) }
      map.creator {|obj| Array.wrap(obj.creator).collect(&:to_s).join(", ") }
      map.title :title
      map.publisher { I18n.t('sufia.institution_name') }
      map.publicationyear {|o| o.date_uploaded.year }
      map.set_identifier { |o,value| o.identifier = value }
    end

  end
end

module ApplicationHelper

  def curation_concern_collection_path(asset)
    collection_path(asset)
  end

  def curation_concern_person_path(person)
    person_path(person)
  end
end
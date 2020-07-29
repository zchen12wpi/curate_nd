module ApplicationHelper

  def curation_concern_collection_path(asset)
    collection_path(asset)
  end

  def curation_concern_person_path(person)
    person_path(person)
  end

  def display_as_grid?
    if (params[:display] == 'grid')
      true
    else
      false
    end
  end

  def display_citation_generation?
    # originally the citation button was not live. Keeping this option in case
    # we change our minds again.
    # !(Rails.env == 'production')
    true
  end

  def include_rich_text_editor?
    (['create', 'edit', 'new'].include? params[:action]) && params[:controller].start_with?('curation_concern')
  end
end

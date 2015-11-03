class AccessRenderer
  def initialize(curation_concern, solr_document = nil)
    if solr_document
      @solr_document = solr_document
    else
      @solr_document = curation_concern.to_solr
    end
  end

  def access_rights_hash
    @access_rights_hash ||= @solr_document.stringify_keys
  end

  def viewable_groups_key
    Hydra.config[:permissions][:read][:group]
  end
  private :viewable_groups_key

  def viewable_groups
    @viewable_groups ||= access_rights_hash[viewable_groups_key]
  end

  def viewable?
    viewable_groups.present?
  end

  def publically_viewable?
    viewable_groups.include?('public')
  end

  def viewable_by_institution?
    viewable_groups.include?('registered')
  end

  def embargo_release_date_key
    Hydra.config[:permissions][:embargo_release_date]
  end
  private :embargo_release_date_key

  def embargo_release_date_value
    access_rights_hash[embargo_release_date_key]
  end
  private :embargo_release_date_value

  def embargo_release_date
    @embargo_release_date ||= DateTime.parse(embargo_release_date_value)
  end

  def human_readable_embargo_release_date
    embargo_release_date.strftime("%Y-%m-%d")
  end

  def has_embargo?
    embargo_release_date_value.present?
  end

  def currently_under_embargo?
    embargo_release_date > DateTime.current
  end

  def extract_dom_label_class_and_link_title
    dom_label_class = 'label-important'
    link_title = 'Private'
    qualifier = ''

    if viewable?
      if has_embargo? && currently_under_embargo?
        dom_label_class = 'label-warning'
        link_title = 'Under Embargo'
        qualifier = "until #{human_readable_embargo_release_date}"
      elsif publically_viewable?
        dom_label_class = 'label-success'
        link_title = 'Open Access'
      elsif viewable_by_institution?
        dom_label_class = 'label-info'
        link_title = I18n.t('sufia.institution_name')
      end
    end
    [dom_label_class, link_title, qualifier]
  end
  private :extract_dom_label_class_and_link_title

  def badge(show_date: false)
    dom_label_class, link_title, qualifier = extract_dom_label_class_and_link_title
    markup = %(<span class="label #{dom_label_class}" title="#{link_title}">#{link_title}</span>).html_safe

    if show_date
      markup << %( <span class="access-rights-qualifier">#{qualifier}</span>).html_safe
    else
      markup
    end
  end
end

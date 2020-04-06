class Oai::QueryBuilder
  include Sufia::Noid

  VALID_KEYS_AND_SEARCH_FIELDNAMES = {
    from: "desc_metadata__date_modified_dtsi",
    until: "desc_metadata__date_modified_dtsi"
  }.freeze

  attr_reader :current_user

  def initialize
    @current_user = nil
  end

  def valid_request?(user_parameters)
    user_parameters.each do |term, value|
      key = term.to_sym
      if VALID_KEYS_AND_SEARCH_FIELDNAMES[key].present?
        return false unless valid_value(key, value)
      end
    end
    return true
  end

  def build_filter_queries(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    user_parameters.each do |term, value|
      key = term.to_sym
      if VALID_KEYS_AND_SEARCH_FIELDNAMES[key].present?
        solr_parameters[:fq] << do_search_for(key, value)
      end
    end
    solr_parameters
  end

    private

  # perform validations of the value of a search term
  def valid_value(key, value)
    case key
    when (:from || :until)
      return valid_date_format?(value)
    when :set
      return valid_set_type
    else
      # no value validation for key
      return true
    end
  end

  def filter_by_set(term)
    set_info = term.split(':',2)
    case set_info[0]
    when 'collection'
      filter_by_part_of(set_info[1])
    when 'model'
      filter_by_worktype(set_info[1])
    else
      # do nothing - not a valid set
    end
  end

  def filter_by_worktype(term)
    require 'byebug'; debugger; true
  end

  def filter_by_part_of(term)
    Sufia::Noid.namespaceize(term)
  end

  # allowed format: "2020-03-31T21:51:03Z"
  def filter_by_from(term)
    term.utc unless term.utc?
    "[#{term.xmlschema} TO *]"
  end

  # allowed format: "2020-03-31T21:51:03Z"
  def filter_by_until(term)
    term.utc unless term.utc?
    "[* TO #{term.xmlschema}]"
  end

  # builds filter query search for a given key & array of elements
  def do_search_for(key, value)
    search_term = self.send("filter_by_#{key}", value)
    prepare_search_term_for(key, search_term)
  end

  def join_for(value)
    " AND "
  end

  def prepare_search_term_for(key, term)
    field = VALID_KEYS_AND_SEARCH_FIELDNAMES[key]
    this_term = field.ends_with?('dtsi') ? term : "\"#{term}\""
    search_term  = "#{field}:#{this_term}"
  end

  def valid_date_format?(value)
    value.is_a?(Time)
  end

  def valid_set_type(term)
    return true if term.start_with?("und:") || term.is_a?(CurationConcern)
    false
  end
end

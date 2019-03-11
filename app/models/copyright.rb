# Responsible for exposing means of looking up a list of copyrights from Locabulary
module Copyright
  PREDICATE_NAME = 'copyright'.freeze
  # @api public
  #
  # Get a list of active copyright terms available for selection
  #
  # @return [Array<#term_label, #term_uri, #description>]
  def self.active
    ControlledVocabularyService.active_entries_for_predicate_name(name: PREDICATE_NAME)
  end

  # Returns a key/value pair of active items available for select
  # @return [Hash]
  def self.active_for_select
    active.each_with_object({}) do |item, hash|
      hash[item.term_label] = item.term_uri
      hash
    end
  end

  def self.default_persisted_value
    persisted_value_for!('All rights reserved')
  end

  def self.label_from_uri(uri)
    ControlledVocabularyService.label_from_uri(name: PREDICATE_NAME, uri: uri)
  end

  def self.persisted_value_for!(value)
    ControlledVocabularyService.item_for_predicate_name(name: PREDICATE_NAME, term_key: 'term_label', term_value: value, ignore_not_found: false).term_uri
  end
end

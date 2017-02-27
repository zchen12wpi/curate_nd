# Responsible for exposing means of looking up a list of copyrights
module Copyright
  PREDICATE_NAME = 'copyright'.freeze
  # @api public
  #
  # Get a list of active copyright terms available for selection
  #
  # @return [Array<#term_label, #term_uri, #description>]
  def self.active
    ::Locabulary.active_items_for(predicate_name: PREDICATE_NAME, as_of: Time.zone.now)
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
    ::Locabulary.active_label_for_uri(predicate_name: PREDICATE_NAME, term_uri: uri)
  end

  def self.persisted_value_for!(value)
    ::Locabulary.item_for(predicate_name: PREDICATE_NAME, term_label: value).term_uri
  end
end

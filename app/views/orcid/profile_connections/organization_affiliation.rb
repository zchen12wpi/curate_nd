class OrganizationAffiliation

  class InvalidAffiliation < RuntimeError
  end

  VALID_ENTITIES = [
    'faculty',
    'staff',
    'graduate',
    'undergraduate',
    'other'
  ]

  def initialize(key)
    if VALID_ENTITIES.include?(key.to_s)
      @key = key
    else
      raise InvalidAffiliation, "The #{key} affiliation does not exist"
    end
  end

  def label
    I18n.t(key, scope: 'curate_nd.organization_affiliation.label')
  end

  def name
    I18n.t(key, scope: 'curate_nd.organization_affiliation.name')
  end

end
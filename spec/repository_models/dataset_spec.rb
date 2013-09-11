# Generated via
#  `rails generate curate:work Dataset`
require 'spec_helper'
require 'active_fedora/test_support'

describe Dataset do
  include ActiveFedora::TestSupport
  subject { Dataset.new }

  include_examples 'is_a_curation_concern_model'
  include_examples 'with_access_rights'
  include_examples 'is_embargoable'

end
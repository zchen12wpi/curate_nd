# Generated via
#  `rails generate curate:work Article`
require 'spec_helper'
require 'active_fedora/test_support'

describe Article do
  include ActiveFedora::TestSupport
  subject { Article.new }

  include_examples 'is_a_curation_concern_model'
  include_examples 'is_doi_assignable_model'
  include_examples 'with_access_rights'
  include_examples 'is_embargoable'

end
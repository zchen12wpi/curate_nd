require 'spec_helper'

describe CurationConcern::FindingAidsController do
  it_behaves_like 'is_a_curation_concern_controller', FindingAid, actions: [:create, :update, :edit]
end

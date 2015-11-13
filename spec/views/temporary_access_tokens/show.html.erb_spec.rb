require 'rails_helper'

RSpec.describe "temporary_access_tokens/show", :type => :view do
  before(:each) do
    @temporary_access_token = assign(:temporary_access_token, TemporaryAccessToken.create!(
      :sha => "Sha",
      :noid => "Noid",
      :issued_by => "Issued By",
      :used => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Sha/)
    expect(rendered).to match(/Noid/)
    expect(rendered).to match(/Issued By/)
    expect(rendered).to match(/false/)
  end
end

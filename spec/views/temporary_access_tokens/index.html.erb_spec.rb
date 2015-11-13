require 'rails_helper'

RSpec.describe "temporary_access_tokens/index", :type => :view do
  before(:each) do
    assign(:temporary_access_tokens, [
      TemporaryAccessToken.create!(
        :sha => "Sha",
        :noid => "Noid",
        :issued_by => "Issued By",
        :used => false
      ),
      TemporaryAccessToken.create!(
        :sha => "Sha",
        :noid => "Noid",
        :issued_by => "Issued By",
        :used => false
      )
    ])
  end

  it "renders a list of temporary_access_tokens" do
    render
    assert_select "tr>td", :text => "Sha".to_s, :count => 2
    assert_select "tr>td", :text => "Noid".to_s, :count => 2
    assert_select "tr>td", :text => "Issued By".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end

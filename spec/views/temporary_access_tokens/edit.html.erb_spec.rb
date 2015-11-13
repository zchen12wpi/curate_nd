require 'rails_helper'

RSpec.describe "temporary_access_tokens/edit", :type => :view do
  before(:each) do
    @temporary_access_token = assign(:temporary_access_token, TemporaryAccessToken.create!(
      :sha => "MyString",
      :noid => "MyString",
      :issued_by => "MyString",
      :used => false
    ))
  end

  it "renders the edit temporary_access_token form" do
    render

    assert_select "form[action=?][method=?]", temporary_access_token_path(@temporary_access_token), "post" do

      assert_select "input#temporary_access_token_sha[name=?]", "temporary_access_token[sha]"

      assert_select "input#temporary_access_token_noid[name=?]", "temporary_access_token[noid]"

      assert_select "input#temporary_access_token_issued_by[name=?]", "temporary_access_token[issued_by]"

      assert_select "input#temporary_access_token_used[name=?]", "temporary_access_token[used]"
    end
  end
end

require 'rails_helper'

RSpec.describe "temporary_access_tokens/new", :type => :view do
  before(:each) do
    assign(:temporary_access_token, TemporaryAccessToken.new(
      :sha => "MyString",
      :noid => "MyString",
      :issued_by => "MyString",
      :used => false
    ))
  end

  it "renders new temporary_access_token form" do
    render

    assert_select "form[action=?][method=?]", temporary_access_tokens_path, "post" do

      assert_select "input#temporary_access_token_sha[name=?]", "temporary_access_token[sha]"

      assert_select "input#temporary_access_token_noid[name=?]", "temporary_access_token[noid]"

      assert_select "input#temporary_access_token_issued_by[name=?]", "temporary_access_token[issued_by]"

      assert_select "input#temporary_access_token_used[name=?]", "temporary_access_token[used]"
    end
  end
end

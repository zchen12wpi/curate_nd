require 'spec_helper'

describe Account do
  let(:current_password) { 'password' }
  let(:attributes) {
    {
      "name"=>"",
      "date_of_birth"=>"",
      "gender"=>"",
      "title"=>"",
      "personal_webpage"=>"",
      "blog"=>"",
      "email"=>"jeremy.n.friesen@gmail.com",
      "alternate_email"=>"jeremy.n.friesen@gmail.com",
      "campus_phone_number"=>"5748315926",
      "alternate_phone_number"=>"5748315926",
      "current_password"=>current_password
    }
  }

  subject { FactoryGirl.create(:account, password: current_password, password_confirmation: current_password)}
  after(:each) do
    subject.person.destroy rescue true
  end

  it 'it updates' do
    expect {
      subject.update_with_password(attributes)
    }.to change { subject.person.reload.email }.to(attributes.fetch('email'))
  end

end

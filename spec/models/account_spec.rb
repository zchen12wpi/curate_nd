require 'spec_helper'

describe Account do
  let(:password) { 'password' }
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
      "alternate_phone_number"=>"5748315926"
    }
  }

  subject { FactoryGirl.create(:account, password: password, password_confirmation: password)}
  after(:each) do
    subject.person.destroy rescue true
  end

  it 'it updates' do
    expect {
      subject.update_with_password(attributes)
    }.to change { subject.person.reload.email }.to(attributes.fetch('email'))
  end

  it 'should have an enumerable .omniauth_providers' do
    expect(described_class.omniauth_providers).to be_a(Enumerable)
  end

end

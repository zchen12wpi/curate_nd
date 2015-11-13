# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :temporary_access_token do
    sha "MyString"
    noid "MyString"
    issued_by "MyString"
    used false
  end
end

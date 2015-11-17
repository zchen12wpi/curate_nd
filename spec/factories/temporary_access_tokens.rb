# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :temporary_access_token do
    sha 'scaxnVc5inR_DKZlpsce4KznPQ'
    noid 'a1b2c3d4'
    issued_by 'vlad_key'
    used false
  end
end

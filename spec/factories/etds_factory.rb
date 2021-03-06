FactoryGirl.define do
  factory :etd do
    ignore do
      user {FactoryGirl.create(:user)}
    end
    sequence(:title) {|n| "Title #{n}"}
    sequence(:abstract) {|n| "Abstract #{n}"}
    sequence(:urn) {|n| "etd-#{n}-test"}
    rights { Copyright.default_persisted_value }
    date_uploaded { Date.today }
    date_modified { Date.today }
    date_created { Date.today }
    date { Date.today }
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    subject "Emerald Ash Borer"
    country "United States of America"
    advisor "Karin Verschoor"
    creator "Somebody Special"
    contributor_attributes({"0"=>{contributor: "Some Body", role: "Some Role"}})
    degree_attributes [{ "level" => "0", "discipline" => "Computer Science", "name" => "BS" }]


    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    }

    factory :private_etd do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_etd do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end

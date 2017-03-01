FactoryGirl.define do
  factory :patent do
    ignore do
      user {FactoryGirl.create(:user)}
    end
    sequence(:title) {|n| "Title #{n}"}
    sequence(:description) {|n| "description #{n}"}
    sequence(:patent_number) {|n| "Patent Number #{n}"}
    rights { Copyright.default_persisted_value }
    date_uploaded { Date.today }
    date_modified { Date.today }
    creator { ["Some Body"] }
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED

    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    }

    factory :private_patent do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_patent do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end

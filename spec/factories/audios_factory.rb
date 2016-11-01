FactoryGirl.define do
  factory :audio do
    ignore do
      user {FactoryGirl.create(:user)}
    end
    sequence(:title) {|n| "Title #{n}"}
    rights { Sufia.config.cc_licenses.keys.first.dup }
    date_uploaded { Date.today }
    date_modified { Date.today }
    creator { ["Some Body"] }
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED

    factory :private_audio do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_audio do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end

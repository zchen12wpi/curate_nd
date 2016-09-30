FactoryGirl.define do
  factory :osf_archive do
    ignore do
      user {FactoryGirl.create(:user)}
    end
    sequence(:title) {|n| "Title #{n}"}
    type { "OSF Archive"}
    rights { Sufia.config.cc_licenses.keys.first.dup }
    creator { ["Some Body"] }
    administrative_unit { ["Some Department"] }
    description { ["An OSF archive"] }
    date_created { Date.today }
    date_modified { Date.today }
    date_archived { Date.today }
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED

    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    }

    factory :private_osf_archive do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_osf_archive do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end

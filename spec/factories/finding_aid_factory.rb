FactoryGirl.define do
  factory :finding_aid, class: 'FindingAid' do
    ignore do
      person {FactoryGirl.create(:person_with_user)}
      user { person.user }
    end
    sequence(:title) {|n| "Title #{n}"}
    date_uploaded { Date.today }
    date_modified { Date.today }
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    rights { Sufia.config.cc_licenses.keys.first.dup }
    sequence(:creator) {|n|["Creator Name#{n}"]}
    abstract 'Hello World!'
    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    }

    factory(:invalid_finding_aid) do
      title ''
    end

    factory :private_finding_aid do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    factory :public_finding_aid do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    factory :finding_aid_with_files do
      ignore do
        file_count 3
      end

      after(:create) do |work, evaluator|
        FactoryGirl.create_list(:generic_file, evaluator.file_count, batch: work, user: evaluator.user)
      end
    end
  end
end

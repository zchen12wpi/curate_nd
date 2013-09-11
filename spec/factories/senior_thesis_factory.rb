FactoryGirl.define do
  factory :senior_thesis, class: 'SeniorThesis' do
    ignore do
      user { FactoryGirl.create(:user) }
    end
    sequence(:title) {|n| "Title #{n}"}
    date_uploaded { Date.today }
    date_modified { Date.today }
    visibility Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    rights { Sufia.config.cc_licenses.keys.first }
    sequence(:creator) {|n|["Creator Name#{n}"]}
    description 'Hello World!'
    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
      work.creator = evaluator.user.to_s
    }
  end

  factory :senior_thesis_invalid, class: 'SeniorThesis' do
    title ''
  end


  factory :private_senior_thesis do
    visibility Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
  end
  factory :public_senior_thesis do
    visibility Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  end
  factory :senior_thesis_with_files do
    ignore do
      file_count 3
    end

    after(:create) do |work, evaluator|
      FactoryGirl.create_list(:generic_file, evaluator.file_count, batch: work, user: evaluator.user)
    end
  end

end

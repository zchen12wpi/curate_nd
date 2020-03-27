class MockFile < Rack::Test::UploadedFile
  attr_accessor :fake_file_name
  # Override this method so that we can provide a fake file name.
  # Several views depend on the datastream label, which is just the
  # the original_filename of the file. This allows you to effectively
  # change what label is displayed in those views. Otherwise, you will
  # see the same label for every file.
  def original_filename
    fake_file_name || super
  end
end

# Creates a new user without duplicating usernames
def create_user(email, name, pw)
  user = User.find_or_create_by(username: name) do |u|
    u.email = email
    u.username = name
    u.password = pw
    u.password_confirmation = pw
  end
  user
end

# Creates a new account associated with a user
def create_account(user)
  account = Account.to_adapter.get!(user.id)
  update_status = account.update_with_password({ "email" => user.email, "name" => user.username })
end

# Creates or finds an object by id. If an actor is given, will use the actor to create
# the object. Otherwise, will just use the new method on the model given
def find_or_create(model, actor, id, user, params)
  curation_concern = model.where(desc_metadata__identifier_tesim: id).first
  if curation_concern.nil?
    curation_concern = model.new(identifier: id)
    if actor.present?
      actor.new(curation_concern, user, params).create
    else
      curation_concern.attributes = params
      curation_concern.apply_depositor_metadata(user.user_key)
      curation_concern.save!
    end
  end
  curation_concern
end

# Creates or finds a library collection by description. If an actor is given, will use the actor to create
# the object. Otherwise, will just use the new method on the model given
def find_or_create_library_collection(description, user, params)
  collection = LibraryCollection.where(desc_metadata__description_tesim: description).first
  if collection.nil?
    collection = LibraryCollection.new
    collection.attributes = params
    collection.apply_depositor_metadata(user.user_key)
    collection.save!
  end
  collection
end

# Shared variables
user_with_profile = create_user('userwithprofile@example.com', 'userwithprofile', 'foobarbaz')
create_account(user_with_profile)
user_without_profile = create_user('userwithoutprofile@example.com', 'userwithoutprofile', 'foobarbaz')
seeds_file = MockFile.new(__FILE__, 'text/plain', false)
date_created = 1.month.ago.strftime("%Y-%m-%d")
publication_date = 1.year.ago.strftime("%Y-%m-%d")
date_issued = 9.months.ago.strftime("%Y-%m-%d")
# Make sure all users are created before this step
everyone_group = Hydramata::Group.new(title: "Everyone", depositor: user_with_profile.username, description: "")
User.all.each { |u| everyone_group.add_member(u.person) }
test_group = Hydramata::Group.new(title: "Test Group", depositor: user_with_profile.username, description: "")
test_group.add_member(user_with_profile.person)

puts "Things with no files"
110.times do |j|
  attributes = { creator: user_with_profile.username, abstract: 'Article abstract', title: "Public Article-#{j}", date_created: date_created, publication_date: publication_date, visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
  puts "#{attributes[:title]}"
  article = find_or_create(Article, CurationConcern::ArticleActor, attributes[:title], user_with_profile, attributes)
  article.add_record_editor_groups([everyone_group])
end

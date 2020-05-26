require 'spec_helper'
require 'active_fedora/test_support'
describe Collection do

  it_behaves_like 'with_json_mapper'

  let(:user) { FactoryGirl.create(:user) }
  let(:generic_work1) { FactoryGirl.create(:generic_work, user: user, title:"My Work 1")}
  let(:generic_work2) {FactoryGirl.create(:generic_work, user: user, title:"My Fabulous Work") }

  before(:each) do
    @collection = Collection.new
    @collection.apply_depositor_metadata(user.user_key)
    @collection.save
  end
  after(:each) do
    @collection.destroy
  end
  it "should have a depositor" do
    expect(@collection.depositor).to eq user.user_key
  end
  it "should allow the depositor to edit and read" do
    ability = Ability.new(user)
    expect(ability.can?(:read, @collection)).to eq(true)
    expect(ability.can?(:edit, @collection)).to eq(true)
  end
  it "should be empty by default" do
    expect(@collection.members).to eq([])
  end

  it "should have many works" do
    @collection.members = [generic_work1, generic_work2]
    @collection.save
    expect(Collection.find(@collection.pid).members).to contain_exactly(generic_work1, generic_work2)
  end
  it "should allow new work to be added" do
    @collection.members = [generic_work1]
    @collection.save
    @collection = Collection.find(@collection.pid)
    @collection.members << generic_work2
    @collection.save
    expect(Collection.find(@collection.pid).members).to contain_exactly(generic_work1, generic_work2)
  end
  it "should set the date uploaded on create" do
    @collection.save
    expect(@collection.date_uploaded).to be_a(Date)
  end
  it "should update the date modified on update" do
    uploaded_date = Date.today
    modified_date = Date.tomorrow
    allow(Date).to receive(:today).and_return(uploaded_date)
    @collection.save
    expect(@collection.date_modified).to eq(uploaded_date)
    @collection.members = [generic_work1]
    allow(Date).to receive(:today).and_return(modified_date)
    @collection.save
    expect(@collection.date_modified).to eq(modified_date)
    new_generic_work1 = GenericWork.find(generic_work1.pid)
    expect(new_generic_work1.collections.include?(@collection)).to be_truthy
    expect(new_generic_work1.to_solr[Solrizer.solr_name(:collection)]).to contain_exactly(@collection.id)
  end
  it "should have a title" do
    @collection.title = "title"
    @collection.save
    expect(Collection.find(@collection.pid).title).to eq(@collection.title)
  end
  it "should have a description" do
    @collection.description = "description"
    @collection.save
    expect(Collection.find(@collection.pid).description).to eq(@collection.description)
  end
  it "should not delete member work when deleted" do
    @collection.members = [generic_work1, generic_work2]
    @collection.save
    @collection.destroy
    expect(GenericWork.exists?(generic_work1.pid)).to be_truthy
    expect(GenericWork.exists?(generic_work2.pid)).to be_truthy
  end

  describe "Collection by another name" do
    before (:all) do
      class OtherCollection < ActiveFedora::Base
        include Hydra::Collection
        include Hydra::Collections::Collectible
      end
      class Member < ActiveFedora::Base
        include Hydra::Collections::Collectible
      end
    end
    after(:all) do
      Object.send(:remove_const, :OtherCollection)
      Object.send(:remove_const, :Member)
    end

    it "have members that know about the collection" do
      collection = OtherCollection.new
      member = Member.create
      collection.members << member
      collection.save
      member.reload
      expect(member.collections).to eq [collection]
      collection.destroy
      member.destroy
    end
  end

end

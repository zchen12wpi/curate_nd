require 'spec_helper'

describe OsfArchive do
  subject { OsfArchive.new }

  it { should have_unique_field(:title) }
  it { should have_unique_field(:source) }
  it { should have_unique_field(:type) }
  it { should have_unique_field(:osf_project_identifier) }

  it_behaves_like 'is_a_curation_concern_model'
  it_behaves_like 'with_access_rights'
  it_behaves_like 'can_be_a_member_of_library_collections'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'with_json_mapper'

  describe 'new archive' do
    let(:archive) {OsfArchive.new}

    it "should set initialize dates and stamp type on create" do
      archive.valid?
      expect(archive.date_modified).to eq(Date.today)
      expect(archive.date_archived).to eq(Date.today)
      expect(archive.type).to eq('OSF Archive')
    end
  end

  describe 'related versions of OSF Archive objects' do
    let(:osf_project_identifier) { 'abcde' }
    let(:osf_registration_identifier) { '12345' }
    let!(:previous_version) do
      FactoryGirl.create(
        :osf_archive,
        source: "https://osf.io/#{osf_project_identifier}",
        osf_project_identifier: osf_project_identifier,
        date_archived: 2.days.ago
      )
    end
    let!(:current_version) do
      FactoryGirl.create(
        :osf_archive,
        previousVersion: previous_version,
        source: "https://osf.io/#{osf_project_identifier}",
        osf_project_identifier: osf_project_identifier,
        date_archived: 1.days.ago
      )
    end
    let!(:project_registration) do
      FactoryGirl.create(
        :osf_archive,
        source: "https://osf.io/#{osf_registration_identifier}",
        osf_project_identifier: osf_project_identifier,
        date_archived: 0.days.ago
      )
    end

    it 'has expected JSON-LD, RELS-EXT, setter/getter behavior, and #archived_versions_of_source_project' do
      osf_archive = OsfArchive.find(current_version.id)

      # Ensuring that the previousVersion works
      expect(osf_archive.previousVersion).to eq(previous_version)

      # Ensuring a well configured SOLR
      to_solr = osf_archive.to_solr
      expect(to_solr.fetch(OsfArchive::SOLR_KEY_SOURCE)).to eq([osf_archive.source])
      expect(to_solr.fetch(OsfArchive::SOLR_KEY_OSF_PROJECT_IDENTIFIER)).to eq([osf_project_identifier])
      expect(to_solr.key?(OsfArchive::SOLR_KEY_ARCHIVED_DATE)).to eq(true)

      # Ensuring #archived_versions_of_source_project
      archived_versions_of_source_project = osf_archive.archived_versions_of_source_project
      expect(archived_versions_of_source_project).to eq([
        previous_version, current_version, project_registration
      ])

      jsonld = osf_archive.as_jsonld
      # Ensuring that the as_jsonld contains the correct relationship
      expect(jsonld.fetch('@context').fetch('pav')).to eq('http://purl.org/pav/')
      expect(jsonld.fetch("pav:previousVersion")).to eq({"@id" => previous_version.pid})

      # Ensuring that we have a meaningful RELS-EXT
      rels_ext = osf_archive.datastreams.fetch('RELS-EXT').content
      expect(rels_ext).to include(%(xmlns:pav="http://purl.org/pav/"))
      expect(rels_ext).to include(%(<pav:previousVersion rdf:resource="info:fedora/#{previous_version.pid}"></pav:previousVersion>))
    end
  end
end

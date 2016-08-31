require 'spec_helper'

describe Admin::IngestOsfArchivesController, type: :controller do
  let(:archive) { instance_double(Admin::IngestOSFArchive, valid?: true) }

  describe 'new' do
    let(:subject) { get :new }

    it 'assigns @archive' do
      allow(Admin::IngestOSFArchive).to receive(:new).and_return(archive)
      subject
      expect(assigns(:archive)).to eq(archive)
    end
  end

  describe '#create' do
    let(:params) { { admin_ingest_osf_archive: { project_identifier: 'id' } } }
    let(:subject) { post :create, params }

    it 'assigns @archive' do
      allow(Admin::IngestOSFArchive).to receive(:new).and_return(archive)
      subject
      expect(assigns(:archive)).to eq(archive)
    end

    it 'creates a new archive with the given params' do
      expect(Admin::IngestOSFArchive).to receive(:new).with(params[:admin_ingest_osf_archive])
      subject
    end

    context 'when the parameters are valid' do
      before(:each) do
        allow(archive).to receive(:valid?).and_return(true)
        allow(Admin::IngestOSFArchive).to receive(:new).and_return(archive)
      end

      it 'uses IngestOSFTools to create a job with the new archive' do
        expect(IngestOSFTools).to receive(:create_osf_job).with(archive)
        subject
      end

      it 'redirects to the index' do
        expect(subject).to redirect_to(action: :index)
      end
    end

    context 'when the parameters are invalid' do
      before(:each) do
        allow(archive).to receive(:valid?).and_return(false)
        allow(Admin::IngestOSFArchive).to receive(:new).and_return(archive)
      end

      it 'uses IngestOSFTools to create a job with the new archive' do
        expect(IngestOSFTools).not_to receive(:create_osf_job).with(archive)
        subject
      end

      it 're-renders new' do
        expect(subject).to render_template(:new)
      end
    end

    context 'when it fails to create the job' do
      before(:each) do
        allow(archive).to receive(:valid?).and_return(true)
        allow(Admin::IngestOSFArchive).to receive(:new).and_return(archive)
        allow(IngestOSFTools).to receive(:create_osf_job).and_return(false)
      end

      it 're-renders new' do
        expect(subject).to render_template(:new)
      end
    end
  end
end

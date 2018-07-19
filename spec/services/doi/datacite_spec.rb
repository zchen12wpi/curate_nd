
module Doi
  RSpec.describe Datacite do
    let(:ezid_identifier) { double(Object, id: 1) }
    let(:curation_concern) { instance_double(ActiveFedora::Base) }
    let(:remapped_hash) { { id: 1 } }
    let(:subject) { Doi::Datacite }

    describe '#mint' do
      it 'uses the DataciteMapper before minting' do
        allow(Ezid::Identifier).to receive(:mint).and_return(ezid_identifier)
        expect(DataciteMapper).to receive(:call).with(curation_concern)
        subject.mint(curation_concern)
      end

      it 'uses the Ezid gem to mint the object with the remapped object' do
        allow(DataciteMapper).to receive(:call).and_return(remapped_hash)
        expect(Ezid::Identifier).to receive(:mint).with(remapped_hash).and_return(ezid_identifier)
        subject.mint(curation_concern)
      end

      it 'returns the id given by Ezid::Identifier' do
        allow(DataciteMapper).to receive(:call).and_return(remapped_hash)
        allow(Ezid::Identifier).to receive(:mint).and_return(ezid_identifier)
        expect(subject.mint(curation_concern)).to eq(ezid_identifier.id)
      end
    end

    describe '#normalize_identifier' do
      it 'returns only the doi when given a url to the resolver instead of the doi' do
        expect(subject.normalize_identifier("#{ENV.fetch('DOI_RESOLVER')}/doi:123")).to eq('doi:123')
      end

      it 'returns the doi with "doi:" prefix if only the numeric identifier is given' do
        expect(subject.normalize_identifier("10.25626/abc123")).to eq('doi:10.25626/abc123')
      end

      context 'removes extra spaces in the identifier' do
        it 'such as " doi:10.25626/abc123"' do
          expect(subject.normalize_identifier(' doi:10.25626/abc123')).to eq('doi:10.25626/abc123')
        end

        it 'such as "doi:10.25626/abc123 "' do
          expect(subject.normalize_identifier('doi:10.25626/abc123 ')).to eq('doi:10.25626/abc123')
        end

        it 'such as "doi: 10.25626/abc123"' do
          expect(subject.normalize_identifier('doi: 10.25626/abc123')).to eq('doi:10.25626/abc123')
        end

        it 'such as "doi :10.25626/abc123"' do
          expect(subject.normalize_identifier('doi :10.25626/abc123')).to eq('doi:10.25626/abc123')
        end

        it 'such as "doi : 10.25626/abc123"' do
          expect(subject.normalize_identifier('doi : 10.25626/abc123')).to eq('doi:10.25626/abc123')
        end

        it 'such as "doi:10.25626 /abc123"' do
          expect(subject.normalize_identifier('doi:10.25626 /abc123')).to eq('doi:10.25626/abc123')
        end

        it 'such as "doi:10.25626/ abc123"' do
          expect(subject.normalize_identifier('doi:10.25626/ abc123')).to eq('doi:10.25626/abc123')
        end

        it 'such as "doi:10.25626 / abc123"' do
          expect(subject.normalize_identifier('doi:10.25626 / abc123')).to eq('doi:10.25626/abc123')
        end

        it 'such as "doi:10.25626 / abc123 "' do
          expect(subject.normalize_identifier('doi:10.25626 / abc123 ')).to eq('doi:10.25626/abc123')
        end

        it 'such as "doi : 10.25626 / abc123 "' do
          expect(subject.normalize_identifier('doi : 10.25626 / abc123 ')).to eq('doi:10.25626/abc123')
        end
      end

      it 'returns the doi without transformation if it is already correct' do
        expect(subject.normalize_identifier('doi:10.25626/abc123')).to eq('doi:10.25626/abc123')
      end
    end

    describe '#remote_uri_for' do
      it 'concatenates the resolver url defined in the env with the identifier given' do
        expect(subject.remote_uri_for('doi:10.25626/abc123').to_s).to eq("#{ENV.fetch('DOI_RESOLVER')}/doi:10.25626/abc123")
      end
    end
  end
end

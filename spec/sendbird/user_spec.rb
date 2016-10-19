require 'spec_helper'

describe Sendbird::User do
  let(:subject) do
    described_class.new('testing_user_interface_1')
  end

  context 'Pending Request' do
    it 'will add a new pending request, with the correct structure' do
      subject.nickname = 'Mckuly'
      expect(subject.pending_requests).to_not be_empty
      expect(subject.pending_requests.first).to be_a Hash
      expect(subject.pending_requests.first.keys).to eq [:method, :args]
    end
  end

  context '#update!' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/update!") do
        subject.update!
      end
    end
    it 'will clear pending_requests after finishing' do
      subject.nickname = 'Mckuly'
      request
      expect(subject.pending_requests).to eq([])
    end

    it '#in_sync?' do
      subject.nickname = 'Mckuly'
      request
      expect(subject.in_sync?).to be_truthy
    end

    context 'Error on request' do
      subject do
        described_class.new('non_existing')
      end
      let(:request) do
        create_dynamic_cassette("#{described_class}/invalid_request") do
          subject.update!
        end
      end
      it 'will raise an Error' do
        subject.nickname = 'Fake ID'
        expect{
          request
        }.to raise_error(described_class::InvalidRequest)
      end

      it 'will clear pending_requests' do
        subject.nickname = 'Fake ID'
        begin
          request
        rescue described_class::InvalidRequest => e
          expect(subject.pending_requests).to eq([])
        end
      end
    end
  end
end

require 'spec_helper'

class ApiClassMock
  def self.update(*args)
  end
end

describe Sendbird::RequestHandler::Request do
  subject do
    described_class.new(pending_requests, ApiClassMock, 'user_id')
  end
  let(:stubbed_response_ok) do
    OpenStruct.new(status: 200)
  end
  let(:stubbed_response_not_ok) do
    OpenStruct.new(status: 500)
  end
  context 'Args as an Array' do
    context 'with arguments' do
      let(:pending_requests) do
        {
          :update => {
            :args => ['Hello', 'foo'],
            :callback=>[]
          }
        }
      end

      it 'will call the api_class with the correct method and arguments' do
        expect(ApiClassMock).to receive(:update).with('user_id', 'Hello', 'foo').and_return(stubbed_response_ok)
        subject.execute
      end
    end

    context 'with empty Array' do
      let(:pending_requests) do
        {
          :update => {
            :args => [],
            :callback=>[]
          }
        }
      end

      it 'will call the api_class with the correct method and arguments' do
        expect(ApiClassMock).to receive(:update).with('user_id').and_return(stubbed_response_ok)
        subject.execute
      end
    end
  end

  context 'Args as a Hash' do
    let(:pending_requests) do
      {
        :update => {
          :args => {name: 'JohnDoe', nickname: 'YOUW'},
          :callback=>[]
        }
      }
    end

    it 'will call the api_class with the correct method and arguments' do
      expect(ApiClassMock).to receive(:update).with('user_id', {name: 'JohnDoe', nickname: 'YOUW'}).and_return(stubbed_response_ok)
      subject.execute
    end
  end

  context 'Invalid Response' do
    let(:pending_requests) do
      {
        :update => {
          :args => {fooo: 'JohnDoe'},
          :callback=>[]
        }
      }
    end
    it 'will raise an error' do
      expect(ApiClassMock).to receive(:update).and_return(stubbed_response_not_ok)
      expect{
        subject.execute
      }.to raise_error Sendbird::InvalidRequest
    end
  end

  context 'Callbacks' do
    let(:pending_requests) do
      {
        :update => {
          :args => {fooo: 'JohnDoe'},
          :callback=>[->(response) { raise StandardError }]
        }
      }
    end
    it 'will execute the callback' do
      expect(ApiClassMock).to receive(:update).and_return(stubbed_response_ok)
      expect{
        subject.execute
      }.to raise_error StandardError
    end
  end
end

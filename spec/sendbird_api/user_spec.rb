require 'spec_helper'

describe SendbirdApi::User do
  context 'Create' do
    let(:request) do
      VCR.use_cassette("#{described_class}/create", erb: {api_token: SendbirdApi.api_key}) do
        described_class.create(user_id: 'testing', nickname: 'Yolo', profile_url: '')
      end
    end

    it 'will create user and return response' do
      expect(request).to be_a(SendbirdApi::Response)
    end

    it 'will create user and return status' do
      expect(request.status).to eq 200
    end

    it 'will create user and return response_body' do
      expect(request.response_body).to be_a Hash
    end
  end
end

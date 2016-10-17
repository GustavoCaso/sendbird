require 'spec_helper'

describe SendbirdApi::Application do
  context 'Create' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/create") do
        described_class.create(name: 'testing_app_creation')
      end
    end

    it 'will create an application' do
      expect(request.body).to be_a Hash
    end
  end

end

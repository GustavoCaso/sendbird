require 'spec_helper'

describe Sendbird::ApplicationApi do
  context 'Create' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/create") do
        described_class.create(name: 'testing_app_creation')
      end
    end

    it 'will create an application' do
      response = request.body
      expect(response).to be_a Hash
      expect(request.status).to eq 200
    end

    it 'return app information' do
      [
        "app_id",
        "name",
        "icon_url",
        "api_token",
      ].each do |key|
        expect(request.body[key]).to_not be_nil
      end
    end
  end

  context 'List' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/list") do
        described_class.list
      end
    end

    it 'will return a list with all the application' do
      expect(request.body['applications']).to be_a Array
    end
  end

  # context 'View' do
  #   let(:request) do
  #     create_dynamic_cassette("#{described_class}/view") do
  #       described_class.view
  #     end
  #   end
  #
  #   it 'will return a the application information based on the api_key' do
  #     [
  #       "app_id",
  #       "name",
  #       "icon_url",
  #       "api_token",
  #     ].each do |key|
  #       expect(request.body[key]).to_not be_nil
  #     end
  #   end
  # end

  

end

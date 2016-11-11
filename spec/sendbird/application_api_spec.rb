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

  context 'Delete App' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/destroy") do
        described_class.destroy
      end
    end

    it 'will delete the application based on api key' do
      expect(request.status).to eq 200
      expect(request.body).to eq({})
    end
  end

  context 'Delete All' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/destroy_all") do
        described_class.destroy_all
      end
    end

    it 'will delete all applications' do
      expect(request.status).to eq 200
      expect(request.body).to eq({})
    end
  end

  context 'Profanity' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/profanity") do
        described_class.profanaty(params)
      end
    end

    let(:params) { {enabled: true, type: 'replace', keywords: 'fuc*'} }
    it 'will set the profanity' do
      expect(request.status).to eq 200
      expect(request.body).to eq({})
    end
  end

  context 'CCU (Concurretly Connected Users)' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/ccu") do
        described_class.ccu
      end
    end

    it 'will show ccu' do
      expect(request.status).to eq 200
      expect(request.body['ccu']).to eq(0)
    end
  end

  context 'MAU (Monthly Active Users)' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/mau") do
        described_class.mau
      end
    end

    it 'will show mau' do
      expect(request.status).to eq 200
      expect(request.body['mau']).to eq(0)
    end
  end

  context 'DAU (Daily Active Users)' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/dau") do
        described_class.dau
      end
    end

    it 'will show dau' do
      expect(request.status).to eq 200
      expect(request.body['dau']).to eq(0)
    end
  end

  context 'Daily Message Count' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/daily_message_count") do
        described_class.daily_message_count
      end
    end

    it 'will show dau' do
      expect(request.status).to eq 200
      expect(request.body['message_count']).to eq(0)
    end
  end



end

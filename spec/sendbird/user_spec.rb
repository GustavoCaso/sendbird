require 'spec_helper'

describe Sendbird::User do
  let(:subject) do
    described_class.new('testing_user_interface_1')
  end

  context 'Getters' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/get_user") do
        subject.get_user
      end
    end

    it '#get_user' do
      expect(request).to be_a Hash
      expect(request.keys).to include('user_id', 'nickname', 'profile_url', 'access_token', 'last_seen_at', 'is_online')
    end
  end

  context 'Pending Request' do
    it 'will add a new pending request, with the correct structure' do
      subject.nickname = 'Mckuly'
      expect(subject.pending_requests.keys).to include(:update)
      expect(subject.pending_requests[:update][:args]).to eq({nickname: 'Mckuly'})
    end
  end

  context '#request!' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/request!") do
        subject.request!
      end
    end
    it 'will clear pending_requests after finishing' do
      subject.nickname = 'Mckuly'
      request
      expect(subject.pending_requests).to eq({})
    end

    it '#in_sync?' do
      subject.nickname = 'Mckuly'
      request
      expect(subject.in_sync?).to be_truthy
    end

    context 'group pending_requests to avoid multiple requests' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/unidy_request") do
          subject.request!
        end
      end

      it 'will merge multiple request if possible' do
        subject.nickname = 'Mckuly'
        subject.profile_url= 'mckuly.com:466'
        subject.issue_access_token= '3754287382g82732'
        subject.timezone= 'Europe/London'
        expect(subject.pending_requests.keys).to include(:update, :update_push_preferences)
        expect(subject.pending_requests[:update][:args].keys).to include(:nickname, :profile_url, :issue_access_token)
      end
    end

    context 'With callback' do
      subject do
        described_class.new('testing_user_interface_1')
      end

      let(:register_gcm_token) do
        create_dynamic_cassette("#{described_class}/register_gcm_token") do
          subject.request!
        end
      end

      let(:unregister_tokens) do
        create_dynamic_cassette("#{described_class}/unregister_tokens") do
          subject.request!
        end
      end

      it 'will register_gcm_token and call the callback function' do
        subject.register_gcm_token('dfeufue8hib7g')
        register_gcm_token
        expect(subject.gcm_tokens).to include('dfeufue8hib7g')
      end

      it 'will delete all tokens' do
        subject.register_gcm_token('dfeufue8hib7g')
        register_gcm_token
        expect(subject.gcm_tokens).to_not be_empty
        subject.unregister_all_device_token
        unregister_tokens
        expect(subject.gcm_tokens).to eq([])
        expect(subject.apns_tokens).to eq([])
      end
    end

    context 'Error on request' do
      subject do
        described_class.new('non_existing')
      end
      let(:request) do
        create_dynamic_cassette("#{described_class}/invalid_request") do
          subject.request!
        end
      end
      it 'will raise an Error' do
        subject.nickname = 'Fake ID'
        expect{
          request
        }.to raise_error(Sendbird::InvalidRequest)
      end

      it 'will clear pending_requests' do
        subject.nickname = 'Fake ID'
        begin
          request
        rescue Sendbird::InvalidRequest => e
          expect(subject.pending_requests).to eq({})
        end
      end
    end
  end
end

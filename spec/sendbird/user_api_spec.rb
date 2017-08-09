require 'spec_helper'

describe Sendbird::UserApi do
  context 'Invalid Request' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/invalid_request") do
        described_class.create(user_id: 'testing', small_name: 'Yolo')
      end
    end

    it do
      expect(request.status).to_not eq 200
    end

    it  do
      expect(request.body['error']).to eq true
      expect(request.body.keys).to include('message')
      expect(request.body.keys).to include('code')
    end
  end

  context 'Create' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/create") do
        described_class.create(user_id: 'testing', nickname: 'Yolo', profile_url: '')
      end
    end

    it 'will create user and return response' do
      expect(request).to be_a(Sendbird::Response)
    end

    it do
      expect(request.status).to eq 200
    end

    it 'will create user and return body' do
      expect(request.body).to be_a Hash
    end
  end

  context 'List' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/list") do
        described_class.list
      end
    end

    it do
      expect(request.status).to eq 200
    end

    it 'will list the user' do
      expect(request.body).to be_a Hash
    end

    it 'will include the next token to fetch more users' do
      expect(request.body['next']).to_not be_empty
    end

    context 'Filter' do
      describe 'Limit' do
        let(:request) do
          create_dynamic_cassette("#{described_class}/list_limit") do
            described_class.list(limit: 3)
          end
        end

        it do
          expect(request.status).to eq 200
        end

        it 'will return just the number specify' do
          expect(request.body['users'].size).to eq 3
        end
      end
    end
  end

  context 'Update' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/update") do
        described_class.update('cvilanova@path.travel', nickname: 'testing_update')
      end
    end

    it do
      expect(request.status).to eq 200
    end

    it 'will update the user' do
      expect(request.body['nickname']).to eq 'testing_update'
    end
  end

  context 'View' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/show") do
        described_class.view('cvilanova@path.travel')
      end
    end

    it do
      expect(request.status).to eq 200
    end

    it 'will return the user data' do
      expect(request.body['user_id']).to eq 'cvilanova@path.travel'
    end
  end

  context 'Unread count' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/unread_count") do
        described_class.unread_count('cvilanova@path.travel')
      end
    end

    it do
      expect(request.status).to eq 200
    end

    it 'will return the number of unread messages' do
      expect(request.body['unread_count']).to eq 0
    end
  end

  context 'Activate' do
    context 'activate' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/activate") do
          described_class.activate('cvilanova@path.travel', activate: true)
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it 'will activate the given user' do
        expect(request.body['user_id']).to eq 'cvilanova@path.travel'
      end
    end

    context 'deactivate' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/deactivate") do
          described_class.activate('cvilanova@path.travel', activate: false)
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it 'will deactivate the given user' do
        expect(request.body).to eq({})
      end
    end
  end

  context 'Block' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/block") do
        described_class.block('cvilanova@path.travel', target_id: 'c1ab00ee-caf3-4796-8f16-a5b4d75a40f1')
      end
    end

    it do
      expect(request.status).to eq 200
    end

    it 'will block the given user' do
      expect(request.body['user_id']).to eq('c1ab00ee-caf3-4796-8f16-a5b4d75a40f1')
    end

    describe 'Get list of blocked users' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/block_list") do
          described_class.block_list('cvilanova@path.travel')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it 'will return the list of blocked user allow with the next token' do
        expect(request.body['users'].size).to eq(1)
        expect(request.body['users'].first['user_id']).to eq('c1ab00ee-caf3-4796-8f16-a5b4d75a40f1')
        # Beacuse there are no more users
        expect(request.body['next']).to be_empty
      end
    end

    describe 'Unblock user' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/unblock") do
          described_class.unblock('cvilanova@path.travel', 'c1ab00ee-caf3-4796-8f16-a5b4d75a40f1')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it 'will unblock the given user' do
        expect(request.body).to eq({})
      end
    end
  end

  describe 'Mark all as read' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/mark_as_read_all") do
        described_class.mark_as_read_all('cvilanova@path.travel')
      end
    end

    it do
      expect(request.status).to eq 200
    end

    it 'will mark all messages as read for given user' do
      expect(request.body).to eq({})
    end
  end

  describe 'Register token' do
    context 'GCM Token' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/register_gcm_token") do
          described_class.register_gcm_token('cvilanova@path.travel', 'testing_gcm')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it 'will create register gcm token' do
        expect(request.body['token']).to eq('testing_gcm')
        expect(request.body['type']).to eq 'GCM'
        expect(request.body['user']['user_id']).to eq 'cvilanova@path.travel'
      end
    end

    context 'APNS Token' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/register_apns_token") do
          described_class.register_apns_token('cvilanova@path.travel', '123abc456def')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it 'will create register gcm token' do
        expect(request.body['token']).to eq('123abc456def')
        expect(request.body['type']).to eq 'APNS'
        expect(request.body['user']['user_id']).to eq 'cvilanova@path.travel'
      end
    end
  end

  describe 'Unregister token' do
    context 'GCM Token' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/unregister_gcm_token") do
          described_class.unregister_gcm_token('cvilanova@path.travel', 'testing_gcm')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it 'will delete registered gcm token' do
        expect(request.body['token']).to eq('testing_gcm')
        expect(request.body['user']['user_id']).to eq 'cvilanova@path.travel'
      end
    end

    context 'APNS Token' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/unregister_apns_token") do
          described_class.unregister_apns_token('cvilanova@path.travel', '123abc456def')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it 'will delete registered gcm token' do
        expect(request.body['token']).to eq('123abc456def')
        expect(request.body['user']['user_id']).to eq 'cvilanova@path.travel'
      end
    end

    context 'All tokens registered' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/unregister_all_device_token") do
          described_class.unregister_all_device_token('cvilanova@path.travel')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it 'will delete all registered tokens' do
        expect(request.body['user']['user_id']).to eq 'cvilanova@path.travel'
      end
    end
  end

  describe 'Push preference' do
    context 'Get preferences' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/push_preferences") do
          described_class.push_preferences('cvilanova@path.travel')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      [
        'do_not_disturb',
        'timezone',
        'start_hour',
        'start_min',
        'end_min',
        'end_hour'].each do |key|
        it do
          expect(request.body.keys).to include(key)
        end
      end
    end

    context 'Update push preferences' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/update_push_preferences") do
          described_class.update_push_preferences('cvilanova@path.travel', timezone: 'Europe/London')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it do
        expect(request.body['timezone']).to eq 'Europe/London'
      end
    end

    context 'Delete push preferences' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/delete_push_preferences") do
          described_class.delete_push_preferences('cvilanova@path.travel')
        end
      end

      it do
        expect(request.status).to eq 200
      end

      it do
        expect(request.body).to eq({})
      end
    end
  end

  context 'Destroy user' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/destroy") do
        described_class.destroy('testing')
      end
    end

    it do
      expect(request.status).to eq 200
    end

    it do
      expect(request.body).to eq({})
    end
  end
end

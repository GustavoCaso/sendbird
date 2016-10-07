require 'spec_helper'

describe SendbirdApi::User do
  context 'Create' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/create") do
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

  context 'List' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/list") do
        described_class.list
      end
    end

    it 'will create user and return status' do
      expect(request.status).to eq 200
    end

    it 'will list the user' do
      expect(request.response_body).to be_a Hash
    end

    it 'will include the next token to fetch more users' do
      expect(request.response_body['next']).to_not be_empty
    end

    context 'Filter' do
      describe 'Limit' do
        let(:request) do
          create_dynamic_cassette("#{described_class}/list_limit") do
            described_class.list(limit: 3)
          end
        end

        it 'will create user and return status' do
          expect(request.status).to eq 200
        end

        it 'will return just the number specify' do
          expect(request.response_body['users'].size).to eq 3
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

    it 'will create user and return status' do
      expect(request.status).to eq 200
    end

    it 'will update the user' do
      expect(request.response_body['nickname']).to eq 'testing_update'
    end
  end

  context 'Show' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/show") do
        described_class.show('cvilanova@path.travel')
      end
    end

    it 'will create user and return status' do
      expect(request.status).to eq 200
    end

    it 'will return the user data' do
      expect(request.response_body['user_id']).to eq 'cvilanova@path.travel'
    end
  end

  context 'Unread count' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/unread_count") do
        described_class.unread_count('cvilanova@path.travel')
      end
    end

    it 'will create user and return status' do
      expect(request.status).to eq 200
    end

    it 'will return the number of unread messages' do
      expect(request.response_body['unread_count']).to eq 0
    end
  end

  context 'Activate' do
    context 'activate' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/activate") do
          described_class.activate('cvilanova@path.travel', activate: true)
        end
      end

      it 'will create user and return status' do
        expect(request.status).to eq 200
      end

      it 'will activate the given user' do
        expect(request.response_body['user_id']).to eq 'cvilanova@path.travel'
      end
    end

    context 'deactivate' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/deactivate") do
          described_class.activate('cvilanova@path.travel', activate: false)
        end
      end

      it 'will create user and return status' do
        expect(request.status).to eq 200
      end

      it 'will deactivate the given user' do
        expect(request.response_body).to eq({})
      end
    end
  end

  context 'Block' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/block") do
        described_class.block('cvilanova@path.travel', target_id: 'c1ab00ee-caf3-4796-8f16-a5b4d75a40f1')
      end
    end

    it 'will create user and return status' do
      expect(request.status).to eq 200
    end

    it 'will block the given user' do
      expect(request.response_body['user_id']).to eq('c1ab00ee-caf3-4796-8f16-a5b4d75a40f1')
    end

    describe 'Get list of blocked users' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/block_list") do
          described_class.block_list('cvilanova@path.travel')
        end
      end

      it 'will create user and return status' do
        expect(request.status).to eq 200
      end

      it 'will return the list of blocked user allow with the next token' do
        expect(request.response_body['users'].size).to eq(1)
        expect(request.response_body['users'].first['user_id']).to eq('c1ab00ee-caf3-4796-8f16-a5b4d75a40f1')
        # Beacuse there are no more users
        expect(request.response_body['next']).to be_empty
      end
    end

    describe 'Unblock user' do
      let(:request) do
        create_dynamic_cassette("#{described_class}/unblock") do
          described_class.unblock('cvilanova@path.travel', 'c1ab00ee-caf3-4796-8f16-a5b4d75a40f1')
        end
      end

      it 'will create user and return status' do
        expect(request.status).to eq 200
      end

      it 'will unblock the given user' do
        expect(request.response_body).to eq({})
      end
    end
  end

  describe 'Mark all as read' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/mark_as_read_all") do
        described_class.mark_as_read_all('cvilanova@path.travel')
      end
    end

    it 'will create user and return status' do
      expect(request.status).to eq 200
    end

    it 'will mark all messages as read for given user' do
      expect(request.response_body).to eq({})
    end
  end
end

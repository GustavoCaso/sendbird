require 'spec_helper'

describe SendbirdApi::OpenChannel do
  GROUP_NAME = 'Testing_api_123'
  context 'Create' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/create") do
        described_class.create(params)
      end
    end

    let(:params) { {channel_url: GROUP_NAME} }
    it 'will create a new Open Channel' do
      expect(request.body['channel_url']).to be_a String
      expect(request.body['participant_count']).to eq 0
    end
  end

  context 'List' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/list") do
        described_class.list(params)
      end
    end

    let(:params) { {} }
    it 'will return all the open channels' do
      expect(request.body['channels']).to be_a Array
    end
  end

  context 'Update' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/update") do
        described_class.update(GROUP_NAME, {name: 'Best Name Ever'})
      end
    end

    it 'will update the open channel' do
      expect(request.body['name']).to eq 'Best Name Ever'
    end
  end

  context 'View' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/view") do
        described_class.view(GROUP_NAME, participants: true)
      end
    end

    it 'will get open channel info' do
      expect(request.body['name']).to eq 'Best Name Ever'
    end
  end

  context 'Delete' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/delete") do
        described_class.destroy('sendbird_open_channel_8242_806626f3ce14fd9a4fc2a83254b284ba7cbe513c')
      end
    end

    it 'will delete the open channel' do
      expect(request.body).to eq({})
    end
  end

  context 'Participants' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/participants") do
        described_class.participants(GROUP_NAME, limit: 5)
      end
    end

    it 'will get participants from open channel' do
      expect(request.body['participants']).to eq([])
      expect(request.body['next']).to eq ''
    end
  end

  context 'Freeze' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/freeze") do
        described_class.freeze(GROUP_NAME, freeze: true)
      end
    end

    it 'will update freeze state from open channel' do
      expect(request.body['freeze']).to eq true
    end
  end

  context 'Ban User' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/ban") do
        described_class.ban_user(GROUP_NAME, user_id: 'nirrrr')
      end
    end

    it 'will ban this user from the open channel' do
      expect(request.body['user']['user_id']).to eq 'nirrrr'
    end
  end

  context 'Ban List' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/ban_list") do
        described_class.ban_list(GROUP_NAME, limit: 3)
      end
    end

    it 'will return list of banned user from channel' do
      expect(request.body['banned_list'].size).to eq 1
    end
  end

  context 'Ban Update' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/ban_update") do
        described_class.ban_update(GROUP_NAME, 'nirrrr', description: 'Just for not good reasons', seconds: 20)
      end
    end

    it 'will update, banned user' do
      expect(request.body['user']['user_id']).to eq 'nirrrr'
      expect(request.body['description']).to eq 'Just for not good reasons'
    end
  end

  context 'Ban View' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/ban_view") do
        described_class.ban_view(GROUP_NAME, 'nirrrr')
      end
    end

    it 'will return banned user info' do
      expect(request.body['user']['user_id']).to eq 'nirrrr'
    end
  end

  context 'Ban Delete' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/ban_delete") do
        described_class.ban_delete(GROUP_NAME, 'nirrrr')
      end
    end

    it 'will remove ban from user' do
      expect(request.body).to eq ({})
    end
  end

  context 'Mute User' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/mute_user") do
        described_class.mute(GROUP_NAME, user_id: 'nirrrr')
      end
    end

    it 'will mute user from group' do
      expect(request.body['name']).to eq ('Best Name Ever')
    end
  end

  context 'Mute List' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/mute_list") do
        described_class.mute_list(GROUP_NAME)
      end
    end

    it 'will return list of mute user from channel' do
      expect(request.body['muted_list']).to be_a Array
      expect(request.body['muted_list'].size).to eq 1
      expect(request.body['muted_list'].first['user_id']).to eq 'nirrrr'
    end
  end

  context 'Mute View' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/mute_view") do
        described_class.mute_view(GROUP_NAME, 'nirrrr')
      end
    end

    it 'will return muted user info' do
      expect(request.body['is_muted']).to eq true
    end
  end

  context 'Mute Delete' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/mute_delete") do
        described_class.mute_delete(GROUP_NAME, 'nirrrr')
      end
    end

    it 'will remove mute from user' do
      expect(request.body).to eq ({})
    end
  end
end

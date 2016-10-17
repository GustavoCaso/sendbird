require 'spec_helper'

describe Sendbird::GroupChannel do
  CHANNEL_URL = 'sendbird_group_channel_19031773_daff0f4d3fc3974311123ca8134b126c242ac8cc'
  USER_ID = 'nirrrr'

  context 'Create' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/create") do
        described_class.create(params)
      end
    end

    let(:params) { {name: 'Testing_group', user_ids: [USER_ID]} }
    it 'will create a new Group Channel' do
      expect(request.body['channel_url']).to be_a String
      expect(request.body['is_distinct']).to eq false
    end
  end

  context 'List' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/list") do
        described_class.list(params)
      end
    end
    context 'Applications Group Channels' do
      let(:params) { {} }
      it 'will return all the group channels' do
        expect(request.body['channels']).to be_a Array
      end
    end

    context 'User Group Channels' do
      let(:params) { {user_id: USER_ID, show_empty: true} }

      it 'will return all the group channels that the user belongs' do
        expect(request.body['channels']).to be_a Array
        expect(request.body['channels'].first['name']).to eq 'Testing_group'
      end
    end
  end

  context 'Update' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/update") do
        described_class.update(CHANNEL_URL, {data: '{\'path\': \'hello\'}'})
      end
    end

    it 'will update the group channel' do
      expect(request.body['data']).to eq '{\'path\': \'hello\'}'
    end
  end

  context 'View' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/view") do
        described_class.view(CHANNEL_URL, {member: true})
      end
    end

    it 'will get group channel info' do
      expect(request.body['name']).to eq 'Testing_group'
      expect(request.body['members']).to be_a Array
    end
  end

  context 'Delete' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/delete") do
        described_class.destroy('sendbird_group_channel_19032077_4468452666c4ee64815911c86e0813851965b92e')
      end
    end

    it 'will delete the group channel' do
      expect(request.body).to eq({})
    end
  end

  context 'Members' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/members") do
        described_class.members(CHANNEL_URL)
      end
    end

    it 'will get all members from group channel' do
      expect(request.body['members']).to be_a Array
      expect(request.body['members'].first['user_id']).to eq USER_ID
    end
  end

  context 'Is Member' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/is_member") do
        described_class.is_member?(CHANNEL_URL, USER_ID)
      end
    end

    it 'will return if the user is member of the group' do
      expect(request.body['is_member']).to eq true
    end
  end

  context 'Invite' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/invite") do
        described_class.invite(CHANNEL_URL, user_ids: ['sam'])
      end
    end

    it 'will invite to the group channel' do
      expect(request.body['members'].size).to eq 2
    end
  end

  context 'Hide' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/hide") do
        described_class.hide(CHANNEL_URL, user_id: 'sam')
      end
    end

    it 'will return hide the group from the user' do
      expect(request.body).to eq({})
    end
  end

  context 'Leave' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/leave") do
        described_class.leave(CHANNEL_URL, user_id: 'sam')
      end
    end

    it 'will make the user leave the group' do
      expect(request.body).to eq({})
    end
  end
  #
  # context 'Ban View' do
  #   let(:request) do
  #     create_dynamic_cassette("#{described_class}/ban_view") do
  #       described_class.ban_view('Testing_api_123', 'nirrrr')
  #     end
  #   end
  #
  #   it 'will return banned user info' do
  #     expect(request.body['user']['user_id']).to eq 'nirrrr'
  #   end
  # end
  #
  # context 'Ban Delete' do
  #   let(:request) do
  #     create_dynamic_cassette("#{described_class}/ban_delete") do
  #       described_class.ban_delete('Testing_api_123', 'nirrrr')
  #     end
  #   end
  #
  #   it 'will remove ban from user' do
  #     expect(request.body).to eq ({})
  #   end
  # end
  #
  # context 'Mute User' do
  #   let(:request) do
  #     create_dynamic_cassette("#{described_class}/mute_user") do
  #       described_class.mute('Testing_api_123', user_id: 'nirrrr')
  #     end
  #   end
  #
  #   it 'will mute user from group' do
  #     expect(request.body['name']).to eq ('Best Name Ever')
  #   end
  # end
  #
  # context 'Mute List' do
  #   let(:request) do
  #     create_dynamic_cassette("#{described_class}/mute_list") do
  #       described_class.mute_list('Testing_api_123')
  #     end
  #   end
  #
  #   it 'will return list of mute user from channel' do
  #     expect(request.body['muted_list']).to be_a Array
  #     expect(request.body['muted_list'].size).to eq 1
  #     expect(request.body['muted_list'].first['user_id']).to eq 'nirrrr'
  #   end
  # end
  #
  # context 'Mute View' do
  #   let(:request) do
  #     create_dynamic_cassette("#{described_class}/mute_view") do
  #       described_class.mute_view('Testing_api_123', 'nirrrr')
  #     end
  #   end
  #
  #   it 'will return muted user info' do
  #     expect(request.body['is_muted']).to eq true
  #   end
  # end
  #
  # context 'Mute Delete' do
  #   let(:request) do
  #     create_dynamic_cassette("#{described_class}/mute_delete") do
  #       described_class.mute_delete('Testing_api_123', 'nirrrr')
  #     end
  #   end
  #
  #   it 'will remove mute from user' do
  #     expect(request.body).to eq ({})
  #   end
  # end
end

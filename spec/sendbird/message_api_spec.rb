require 'spec_helper'

describe Sendbird::MessageApi do
  OPEN_CHANNEL_URL = 'Testing_api_123'
  GROUP_CHANNEL_URL = 'sendbird_group_channel_19031773_daff0f4d3fc3974311123ca8134b126c242ac8cc'

  context 'Create' do
    let(:params) do
      {
        "message_type": "MESG",
        "user_id": 'nirrrr',
        "message": 'Tetsing messages',
        "data": 'Not real'
      }
    end
    let(:request) do
      create_dynamic_cassette("#{described_class}/send") do
        described_class.send(channel_type, channel_url, params)
      end
    end
    context 'Message to open channel' do
      let(:channel_type) { 'open_channels' }
      let(:channel_url) { OPEN_CHANNEL_URL }
      it 'will create a message in the open channel' do
        expect(request.body['message']).to eq 'Tetsing messages'
        expect(request.body['channel_url']).to eq OPEN_CHANNEL_URL
      end
    end

    context 'Message to group channel' do
      let(:channel_type) { 'group_channels' }
      let(:channel_url) { GROUP_CHANNEL_URL }
      it 'will create a message in the group channel' do
        expect(request.body['message']).to eq 'Tetsing messages'
        expect(request.body['channel_url']).to eq GROUP_CHANNEL_URL
      end
    end
  end

  context 'List' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/list") do
        described_class.list('open_channels', OPEN_CHANNEL_URL, {message_ts: 0})
      end
    end
    it 'will return all messages from the channel if you pay :( ' do
      expect(request.status).to eq 400
    end
  end

  context 'View' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/view") do
        described_class.view('open_channels', OPEN_CHANNEL_URL, '527575816' )
      end
    end
    it 'will return the message' do
      expect(request.body['message']).to eq('Tetsing messages')
      expect(request.body['user']['user_id']).to eq('nirrrr')
    end
  end

  context 'Delete' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/delete") do
        described_class.destroy('open_channels', OPEN_CHANNEL_URL, '527575816' )
      end
    end
    it 'will delete the message' do
      expect(request.body).to eq({})
    end
  end

  context 'Mark as Read' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/mark_as_read") do
        described_class.mark_as_read('group_channels', GROUP_CHANNEL_URL, {user_id: 'nirrrr'} )
      end
    end
    it 'will markall messages from group as readed' do
      expect(request.body).to eq({})
    end
  end

  context 'Count' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/count") do
        described_class.count('group_channels', GROUP_CHANNEL_URL )
      end
    end
    it 'will return the total messages from channel' do
      expect(request.body['total']).to eq(3)
    end
  end

  context 'Unread Count' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/unread_count") do
        described_class.unread_count('group_channels', GROUP_CHANNEL_URL, {user_ids: 'nirrrr'} )
      end
    end
    it 'will all unread messages from channel' do
      expect(request.body['unread']['nirrrr']).to eq(0)
    end
  end
end

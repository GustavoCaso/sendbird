require 'spec_helper'

describe Sendbird::MetaCounter do
  OPEN_CHANNEL_URL = 'Testing_api_123'
  GROUP_CHANNEL_URL = 'sendbird_group_channel_19031773_daff0f4d3fc3974311123ca8134b126c242ac8cc'

  context 'Create' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/create") do
        described_class.create(channel_type, channel_url, {metacounter: { days: 15, year: 2015 }})
      end
    end
    context 'MetaData to open channel' do
      let(:channel_type) { 'open_channels' }
      let(:channel_url) { OPEN_CHANNEL_URL }
      it 'will create a metacounter in the open channel' do
        expect(request.body).to eq ({"days" => 15,"year" => 2015})
      end
    end

    context 'MetaData to group channel' do
      let(:channel_type) { 'group_channels' }
      let(:channel_url) { GROUP_CHANNEL_URL }
      it 'will create a metacounter in the group channel' do
        expect(request.body).to eq ({"days" => 15,"year" => 2015})
      end
    end
  end

  context 'View' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/view") do
        described_class.view('group_channels', GROUP_CHANNEL_URL)
      end
    end

    it 'will return metacounter from the group' do
      expect(request.body).to eq ({"days" => 15,"year" => 2015})
    end
  end

  context 'View By Key' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/view_by_key") do
        described_class.view_by_key('group_channels', GROUP_CHANNEL_URL, 'days')
      end
    end

    it 'will return metacounter from the group by key' do
      expect(request.body).to eq ({"days"  => 15})
    end
  end

  context 'Update' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/update") do
        described_class.update('group_channels', GROUP_CHANNEL_URL, {
          metacounter: {
            days: 15
          },
          mode: 'increase',
          upsert: true
        })
      end
    end

    it 'will update metacounter from the group' do
      expect(request.body).to eq ({"days"  => 30})
    end
  end

  context 'Update by Key' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/update_by_key") do
        described_class.update_by_key('group_channels', GROUP_CHANNEL_URL, 'days',{
          value: 20,
          mode: 'increase',
          upsert: true
        })
      end
    end

    it 'will return metacounter from the group by key' do
      expect(request.body).to eq ({"days"  => 50})
    end
  end

  context 'Delete' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/delete") do
        described_class.destroy(channel_type, channel_url)
      end
    end
    context 'MetaData to open channel' do
      let(:channel_type) { 'open_channels' }
      let(:channel_url) { OPEN_CHANNEL_URL }
      it 'will destroy metacounter in the open channel' do
        expect(request.body).to eq ({})
      end
    end

    context 'MetaData to group channel' do
      let(:channel_type) { 'group_channels' }
      let(:channel_url) { GROUP_CHANNEL_URL }
      it 'will destroy metacounter in the group channel' do
        expect(request.body).to eq ({})
      end
    end
  end

  context 'Delete by Key' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/delete_by_key") do
        described_class.create('group_channels', GROUP_CHANNEL_URL, {metacounter: { days: 15, year: 2015 }})
        described_class.destroy_by_key('group_channels', GROUP_CHANNEL_URL, 'days')
      end
    end

    it 'will destroy metacounter by key the group channel' do
      expect(request.body).to eq ({})
    end
  end
end

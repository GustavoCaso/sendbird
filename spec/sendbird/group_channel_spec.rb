require 'spec_helper'

describe Sendbird::GroupChannel do
  let(:subject) do
    described_class.new('channel_url', 'user_id')
  end

  context 'update pending params and return instance of GroupChannel' do
    it '#name=' do
      expect(subject.pending_requests).to eq({})
      subject.name = 'new_name'
      expect(subject.pending_requests).to eq({:update=>{:args=>{:name=>"new_name"}, :callback=>[]}})
    end

    it '#cover_url=' do
      expect(subject.pending_requests).to eq({})
      subject.cover_url= 'http://www.google.com'
      expect(subject.pending_requests).to eq({:update=>{:args=>{:cover_url=>'http://www.google.com'}, :callback=>[]}})
    end
  end

  context 'Message' do
    it 'return an message instance' do
      expect(subject.message).to be_a Sendbird::Message
    end

    it 'set correct attributes for the message' do
      message = subject.message
      expect(message.user_id).to eq 'user_id'
      expect(message.channel_url).to eq 'channel_url'
      expect(message.channel_type).to eq 'group_channels'
    end

    context 'Without user_id' do
      it 'raise MissingUserId' do
        group_channel = described_class.new('channel_url')
        expect{
          group_channel.message
        }.to raise_exception described_class::MissingUserId
      end
    end
  end
end

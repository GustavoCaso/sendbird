require 'spec_helper'

describe Sendbird::Message do
  subject { described_class.new('user_id', 'channel_url', 'group_channels') }
  context 'create correct parms for sending message' do
    it 'type text' do
      expected_args = {
        "message_type": 'MESG',
        "user_id": 'user_id',
        "message": 'hello group'
      }
      expect(Sendbird::MessageApi).to receive(:send).with('group_channels', 'channel_url', expected_args)
      subject.send(:text, {message: 'hello group'})
    end

    it 'type file' do
      expected_args = {
        "message_type": 'FILE',
        "user_id": 'user_id',
        "url": 'http://www.google.com'
      }
      expect(Sendbird::MessageApi).to receive(:send).with('group_channels', 'channel_url', expected_args)
      subject.send(:file, {url: 'http://www.google.com'})
    end

    it 'type admin' do
      expected_args = {
        "message_type": 'ADMM',
        "message": 'hello group'
      }
      expect(Sendbird::MessageApi).to receive(:send).with('group_channels', 'channel_url', expected_args)
      subject.send(:admin, {message: 'hello group'})
    end
  end

  context 'Invalid type' do
    it 'raise InvalidMessageType' do
      expect{
        subject.send(:non_exist_type, {message: 'Not going to work'})
      }.to raise_exception(described_class::InvalidMessageType)
    end
  end
end

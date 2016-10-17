require 'spec_helper'

describe Sendbird::User do
  let(:response) do
    Sendbird::Response.new(
      200,
      {
        "user_id":"testing",
        "access_token":"",
        "is_online":false,
        "last_seen_at":0,
        "nickname":"Yolo",
        "profile_url":""
      }.to_json
    )
  end
  let(:subject) do
    described_class.find_or_create(response)
  end

  context 'Create' do
    let(:request) do
      create_dynamic_cassette("#{described_class}/create") do
        described_class.find_or_create(user_id: 'testing_user_interface_1', nickname: 'New UX', profile_url: '')
      end
    end

    it 'will return an User instance' do
      expect(request).to be_a Sendbird::User
    end

    it 'will create the user from the internet, after looking for it' do
      expect(Sendbird::UserApi).to receive(:show).with('testing_user_interface_1').and_call_original
      expect(Sendbird::UserApi).to receive(:create).with(user_id: 'testing_user_interface_1', nickname: 'New UX', profile_url: '').and_call_original
      request
    end
  end
end

require 'spec_helper'

describe Sendbird::User do
  context 'Create' do
    let(:subject) do
      create_dynamic_cassette("Sendbird_UserApi/create") do
        described_class.create_or_initialize(user_id: 'testing', nickname: 'Yolo', profile_url: '')
      end
    end

    it 'will return an User instance' do
      expect(subject).to be_a Sendbird::User
    end

    it 'will fetch the user from the internet' do
      expect(Sendbird::UserApi).to receive(:show).with('testing').and_call_original
      subject
    end
  end
end

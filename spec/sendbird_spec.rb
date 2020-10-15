require "spec_helper"

describe Sendbird do
  context '.configure' do
    it 'raises if no configuration is provided' do
      expect do
        Sendbird.configure do |config|
        end
      end.to raise_error(Sendbird::Configuration::MissingConfigurationError)

      expect { Sendbird.config }.to raise_error(Sendbird::NotConfiguredError)
    end

    it 'stores config' do
      Sendbird.configure do |config|
        config.api_token = 'test'
        config.app_id = 'test'
        config.username = 'test'
        config.password = 'test'
      end

      config = Sendbird.config

      expect('test').to eq(config.api_token)
      expect('test').to eq(config.app_id)
      expect('test').to eq(config.username)
      expect('test').to eq(config.password)
    end
  end
end

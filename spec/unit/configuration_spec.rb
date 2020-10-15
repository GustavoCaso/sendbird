require 'spec_helper'

describe Sendbird::Configuration do
  let(:configuration) { Sendbird::Configuration.new }

  context '#validate!' do
    it 'raises if setting are missing' do
      expect { configuration.validate! }.to raise_error(Sendbird::Configuration::MissingConfigurationError)
    end

    it 'does not raise if all values are present' do
      configuration.config.api_token = 'test'
      configuration.config.app_id = 'test'
      configuration.config.username = 'test'
      configuration.config.password = 'test'

      expect { configuration.validate! }.not_to raise_error
    end
  end
end


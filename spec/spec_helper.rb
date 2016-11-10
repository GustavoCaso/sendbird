$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "sendbird"
require 'yaml'
require 'pry'
# Setup shared_examples
Dir["./spec/support/shared_examples/**/*.rb"].each { |f| require f }
# Setup
config_file = File.expand_path('../../config/secrets.yml', __FILE__)
configuration = if File.exist?(config_file)
                  YAML.load(File.read(config_file))
                else
                  # This condition is just for Travis
                  {'api_key' => ENV['API_KEY']}
                end

SendbirdApi.config do |config|
  config.api_key     = configuration['api_key']
  config.user        = configuration['user']
  config.password    = configuration['password']
end

def create_dynamic_cassette(name)
  VCR.use_cassette(name, erb: {api_token: Sendbird.api_key}) do
    yield
  end
end

# Setup for test requests
require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/support/cassettes'
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
end

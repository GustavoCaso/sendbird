require 'spec_helper'

class RequestDummy
  extend Sendbird::Client
  ENDPOINT = 'testing'.freeze
end

describe Sendbird::Client do
  subject { RequestDummy }

  describe 'Request methods' do
    [
      :get,
      :post,
      :put,
      :delete,
      :get_http_basic,
      :post_http_basic,
      :put_http_basic,
      :delete_http_basic,
    ].each do |method|
      it "respond to #{method}" do
        expect(subject).to respond_to(method)
      end
    end
  end

  context '#build_url' do
    context 'with args' do
      it 'prepend ENDPOINT to the list of args and join them' do
        expected_result = 'testing/is/good/practice'

        expect(subject.build_url('is', 'good', 'practice')).to eq expected_result
      end
    end

    context 'without args' do
      it 'return the ENDPOINT' do
        expect(subject.build_url).to eq subject::ENDPOINT
      end
    end
  end

  context 'Api-Token' do
    context 'Passing app parameter' do
      before do
        stub_request(:get, %r/api.sendbird.com\/v3\/not_valid_one\?foo=bar/).
          with(headers: {'Accept'=>'*/*', 'Api-Token'=>Sendbird.applications['Test_2']}).
          to_return(status: 200, body: '{}', headers: {})
      end
      it 'set the valid api token for the app specific' do
        subject.get(path: 'not_valid_one', params: {foo: 'bar', app: 'Test_2'})
      end
    end

    context 'Passing wrong app parameter' do
      it 'raise an exception' do
        expect {
          subject.get(path: 'not_valid_one', params: {foo: 'bar', app: 'Test_incorrect'})
        }.to raise_error(described_class::NotValidApplication)
      end
    end

    context 'Not set default app' do
      it 'raise an exception' do
        allow(Sendbird).to receive(:default_app).and_return(nil)
        expect {
          subject.get(path: 'not_valid_one', params: {foo: 'bar'})
        }.to raise_error(described_class::ApiKeyMissingError)
      end
    end
  end

  context 'Http Basic Auth' do
    context 'With user and password set' do
      before do
        stub_request(:get, %r/api.sendbird.com\/v3\/not_valid_one\?foo=bar/).
          with(basic_auth: [Sendbird.user, Sendbird.password]).
          to_return(status: 200, body: '{}', headers: {})
      end
      it 'set Auth Header correctly' do
        subject.get_http_basic(path: 'not_valid_one', params: {foo: 'bar'})
      end
    end

    context 'User and password not set' do
      it 'raise an exception' do
        allow(Sendbird).to receive(:user).and_return(nil)
        allow(Sendbird).to receive(:password).and_return(nil)

        expect {
          subject.get_http_basic(path: 'not_valid_one', params: {foo: 'bar'})
        }.to raise_error(described_class::HttpBasicMissing)
      end
    end
  end
end

require 'spec_helper'

describe Sendbird::RequestHandler::RequestMerger do
  subject do
    described_class.call({}, method, args, callbacks)
  end
  context 'Arguments as Array' do
    let(:method) { :update }
    let(:args) { ['Hello', 'foo'] }
    let(:callbacks) { [] }

    it 'append the correct args to the method call' do
      expected_value = {:update=>{:args=>[["Hello", "foo"]], :callback=>[[]]}}
      expect(subject).to eq expected_value
    end
  end

  context 'Arguments as Hash' do
    let(:method) { :update }
    let(:args) { {'Hello' => 'World', 'foo' => 'baz'} }
    let(:callbacks) { [] }

    it 'append the correct args to the method call' do
      expected_value = {:update=>{:args=>{'Hello' => 'World', 'foo' => 'baz'}, :callback=>[[]]}}
      expect(subject).to eq expected_value
    end
  end

  context 'Arguments contains callback' do
    let(:method) { :update }
    let(:args) { ['Hello', 'foo'] }
    let(:callbacks) { [->(response) { puts 'Hello from callback' }] }

    it 'append the callback to the method call' do
      expect(subject[method][:callback]).to_not be_empty
    end
  end
end

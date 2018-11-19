require 'rails_helper'

RSpec.describe Search do
  describe '.find' do
    %w[Question Answer Comment User].each do |resource|
      it "receives param #{resource}" do
        expect(resource.classify.constantize).to receive(:search).with('test')
        Search.execute('test', resource)
      end
    end
  end
end
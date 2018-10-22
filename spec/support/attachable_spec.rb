require 'rails_helper'

RSpec.shared_examples_for "attachable" do
  let(:model) { described_class }
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

  before { @resource = create(model.to_s.underscore.to_sym) }

  describe 'have #attachments_attributes' do
    let!(:attachment) { create(:attachment, attachable: @resource) }

    before do
      @response = @resource.attachments_attributes
      @elem = @response.first
    end

    it 'return Hash' do
      expect(@response).to be_a(Array)
    end

    it 'has key "id"' do
      expect(@elem.key?(:id)).to be_truthy
    end

    it 'has key "name"' do
      expect(@elem.key?(:name)).to be_truthy
    end

    it 'has key "url"' do
      expect(@elem.key?(:url)).to be_truthy
    end
  end
end

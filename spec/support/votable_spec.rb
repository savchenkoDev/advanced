require 'rails_helper'

RSpec.shared_examples_for "votable" do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:author) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  before { @resource = create(model.to_s.underscore.to_sym, user: user) }

  it 'have #rating' do
    expect(@resource.rating).to eq 0
    create_list(:vote, 2, votable: @resource, user: author)
    expect(@resource.rating).to eq 2
  end
end

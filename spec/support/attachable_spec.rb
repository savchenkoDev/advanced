require 'rails_helper'

RSpec.shared_examples_for "attachable" do
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

end

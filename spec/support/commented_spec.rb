require 'rails_helper'

RSpec.shared_examples_for 'commented' do
  describe 'POST #create_comment' do
    before { sign_in(user) }

    it ' - saves new Vote in the database' do
      expect { post :create_comment, params: { id: resource, commentable: "#{klass_name(resource)}", "#{klass_name(resource)}": attributes_for("#{klass_name(resource)}_comment") }, format: :json }.to change(resource.comments, :count)
    end

    it '- link Vote with current user' do
      expect{ post :create_comment, params: { id: resource, commentable: "#{klass_name(resource)}", "#{klass_name(resource)}": attributes_for("#{klass_name(resource)}_comment") }, format: :json }.to change(user.comments, :count).by(1)
    end

    it '- should be successful' do
      post :create_comment, params: { id: resource, commentable: "#{klass_name(resource)}", "#{klass_name(resource)}": attributes_for("#{klass_name(resource)}_comment") }, format: :json
      expect(response).to be_successful
    end
  end

  private

  def klass_name(object)
    object.class.name.underscore
  end
end
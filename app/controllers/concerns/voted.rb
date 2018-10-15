module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[destroy_vote like dislike]
  end

  def like
    if current_user.voted?(@votable)
      render json: @vote&.errors&.messages, status: :unprocessable_entity
    elsif !current_user.author_of?(@votable)
      new_vote(1)
      if @vote.save
        render json: {id: @votable.id , rating: @votable.rating } 
      else
        render json: @vote&.errors&.messages, status: :unprocessable_entity
      end
    else
      render json: @vote&.errors&.messages, status: :bad_request
    end
  end

  def dislike
    if current_user.voted?(@votable)
      render json: @vote&.errors&.messages, status: :unprocessable_entity
    elsif !current_user.author_of?(@votable)
      new_vote(-1)
      if @vote.save
        render json: {id: @votable.id , rating: @votable.rating }
      else
        render json: @vote&.errors&.messages, status: :unprocessable_entity
      end
    else
      render json: @vote&.errors&.messages, status: :bad_request
    end

  end

  def destroy_vote
    @vote = @votable.votes.find_by(user: current_user)
    if @vote
      @vote.destroy
      render json: {id: @votable.id , rating: @votable.rating, type: action_name }
    else
      render json: @vote&.errors&.messages, status: :not_found
    end
  end

  private

  def new_vote(vote)
    @vote = @votable.votes.new(vote: vote, user: current_user)
  end
  
  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end 
  
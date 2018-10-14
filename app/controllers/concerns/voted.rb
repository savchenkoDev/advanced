module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[destroy_vote like dislike]
  end

  def like
    if current_user.voted?(@votable)
      respond_to do |format|
        format.json { render json: @vote&.errors&.messages, status: :unprocessable_entity }
      end
    elsif !current_user.author_of?(@votable)
      new_vote(1)
      respond_to do |format|
        if @vote.save
          format.json { render json: {id: @votable.id , rating: @votable.rating } }
        else
          format.json { render json: @vote&.errors&.messages, status: :unprocessable_entity }
        end
      end
    end
  end

  def dislike
    if current_user.voted?(@votable)
      respond_to do |format|
        format.json { render json: @vote&.errors&.messages, status: :unprocessable_entity }
      end
    elsif !current_user.author_of?(@votable)
      new_vote(-1)

      respond_to do |format|
        if @vote.save
          format.json { render json: {id: @votable.id , rating: @votable.rating } }
        else
          format.json { render json: @vote&.errors&.messages, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy_vote
    @vote = @votable.votes.find_by(user: current_user)
    respond_to do |format|
      if @vote
        @vote.destroy
        format.json { render json: {id: @votable.id , rating: @votable.rating, type: action_name } }
      else
        format.json { render json: @vote&.errors&.messages, status: :not_found }
      end
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
  
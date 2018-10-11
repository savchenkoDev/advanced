class VotesController < ApplicationController
  before_action :find_question, only: %i[like dislike]
  before_action :find_vote, only: :destroy

  def like
    @vote = Vote.create(votable: @question, user: current_user, vote: 1)

    respond_to do |format|
      format.json { render @vote }
    end
  end

  def dislike
    @vote = Vote.create(votable: @question, user: current_user, vote: -1)

    respond_to do |format|
      format.json { render @vote }
    end
  end

  def destroy
    @vote.destroy if current_user.author_of?(@vote)
    respond_to do |format|
      format.json { render :destroy }
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_vote
    @vote = Vote.find(params[:id])
  end
end
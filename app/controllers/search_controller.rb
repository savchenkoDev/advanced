class SearchController < ApplicationController

  def index
    @results = Search.execute(params[:search][:query], params[:search][:resource]) if params[:search][:query].present?
  end 
end

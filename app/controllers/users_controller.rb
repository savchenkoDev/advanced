class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit_email; end

  def update_email
    current_user.email = params[:email]
    if current_user.save
      redirect_to root_path, notice: "Successfully authenticated from Vkontakte account."
    else
      render :edit_email
    end
  end
end

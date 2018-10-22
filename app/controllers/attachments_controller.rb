class AttachmentsController < ApplicationController
  respond_to :js

  def destroy
    @attachment = Attachment.find(params[:id])
    respond_with(@attachment.destroy) if current_user.author_of?(@attachment.attachable)
  end
end
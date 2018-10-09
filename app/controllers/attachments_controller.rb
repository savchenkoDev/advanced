class AttachmentsController < ApplicationController
  

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy if current_user.author_of?(@attachment.attachable)
  end

  private
  
  def find_attachment
    @attachment = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:file)
  end
end

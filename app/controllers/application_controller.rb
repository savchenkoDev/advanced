require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { head :forbidden }
      format.js { head :forbidden }
      format.json { head :forbidden }
    end
  end
end

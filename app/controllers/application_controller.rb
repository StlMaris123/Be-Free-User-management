# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :authenticate_user!

  protected

  def json_request?
    request.format.json?
  end

  def after_sign_in_path_for(resource)
    current_user.update!(session_id: cookies['_be_free_session'])
    stored_location_for(resource)
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
 

  protected
  def json_request?
    request.format.json?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[phone_number first_name
                                                         last_name age status gender
                                                         address nick_name latitude longitude])
  end

  def after_sign_in_path_for(resource)
    current_user.update!(session_id: cookies['_be_free_session'])
    stored_location_for(resource)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end

# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  protected

  def update_resource(resource, params)
    if current_user&.refresh_token&.present?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[phone_number first_name
                                                         last_name age status gender
                                                         address nick_name latitude longitude])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[phone_number first_name
                                                                last_name age status gender
                                                                address nick_name latitude longitude])
  end
end

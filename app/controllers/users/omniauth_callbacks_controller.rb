# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      auth = request.env['omniauth.auth']
      @user.access_token = auth.credentials.token
      @user.expires_at = auth.credentials.expires_at
      @user.refresh_token = auth.credentials.refresh_token
      @user.save!
      sign_in(@user)
      @user.update!(session_id: cookies['_be_free_session'])
      redirect_to edit_user_registration_path(@user)
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end

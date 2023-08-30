# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong!'
    end
  end

  def vkontakte
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    elsif !auth[:info]&.dig(:email)
      session[:oauth] = { provider: auth[:provider], uid: auth[:uid].to_s }
      render auth_without_email_path
    else
      redirect_to root_path, alert: 'Something went wrong!'
    end
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end

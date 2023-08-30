class UsersController < ApplicationController

  def auth_without_email
    return redirect_to root_path unless session[:oauth]

    password = Devise.friendly_token[0, 20]
    @user = User.new(email: user_params[:email], password: password, password_confirmation: password)

    if @user.save
      @user.create_authorization(oauth)
      redirect_to root_path
    else
      render :auth_without_email
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def oauth
    Struct.new(:provider, :uid).new(session[:oauth]['provider'], session[:oauth]['uid'])
  end

end

class AuthenticationController < ApplicationController
  # POST /auth/login
  def login
    @user = User.find_by_username(params[:username])
    @user = User.find_by_email(params[:email]) unless @user

    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i

      render json: {
        token: token,
        expiration: time.strftime("%m-%d-%Y %H:%M"),
        username: @user.username
      }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:username, :email, :password)
  end
end

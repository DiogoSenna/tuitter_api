class AuthenticationController < ApplicationController
  # POST /auth/login
  def login
    @user = User.where(username: params[:username])
                .or(User.where(email: params[:email]))
                .first

    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)

      render json: {
        token: token,
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

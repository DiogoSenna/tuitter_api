class AuthenticationController < ApplicationController
  before_action :authorize_request, only: %i[logout me change_password]

  def login
    @user = User.where(username: params[:username])
                .or(User.where(email: params[:email]))
                .first

    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)

      render json: {
        token: token,
        user: @user.as_json(except: [:id, :password_digest]),
      }
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def logout
    jti = @decoded_token[:jti]
    exp = Time.at(@decoded_token[:exp]).to_datetime

    BlacklistedToken.create!(jti: jti, exp: exp)
  end

  def me
    @current_user
  end

  def change_password
    return head :no_content if @current_user.update(password_params)

    render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def login_params
    params.permit(:username, :email, :password)
  end

  def password_params
    params.permit(:password, :password_confirmation, :password_challenge)
          .with_defaults(password_challenge: '')
  end
end

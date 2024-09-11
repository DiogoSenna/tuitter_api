class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end

  def unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def home
    render json: { message: 'Tuitter API', version: '0.1.0' }
  end

  def authorize_request
    token = request.headers['Authorization']&.split(' ')&.last

    return unauthorized unless token

    @decoded_token = JsonWebToken.decode(token)

    return unauthorized if BlacklistedToken.exists?(jti: @decoded_token[:jti])

    @current_user = User.find(@decoded_token[:user_id])

  rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
    render json: { errors: e.message }, status: :unauthorized
  end
end

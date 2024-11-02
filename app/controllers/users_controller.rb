class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :set_user, only: %i[ show update destroy ]
  authorize_resource

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user
  end

  def create
    user = User.new(new_user_params)

    return unprocessable_entity(user.errors) unless user.save

    render json: user, status: :created, location: user
  end

  def update
    return unprocessable_entity(@user.errors) unless @user.update(user_params)

    render json: @user
  end

  def destroy
    @user.destroy!
  end

  private
    def set_user
      @user = User.find_by!(username: params[:username])
    end

    def new_user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

    def user_params
      params.require(:user).permit(:username, :email)
    end
end

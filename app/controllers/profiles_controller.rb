class ProfilesController < ApplicationController
  before_action :authorize_request
  before_action :set_user

  def show
    render json: @user.profile
  end

  def create
    @profile = @user.build_profile(profile_params)

    if @profile.save
      render json: @profile, status: :created
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.profile.update(profile_params)
      render json: @user.profile
    else
      render json: @user.profile.errors, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find_by!(username: params[:user_username])
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :birth_date, :city, :country, :state)
    end
end

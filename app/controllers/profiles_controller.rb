class ProfilesController < ApplicationController
  before_action :authorize_request
  before_action :set_user

  def show
    render json: @user.profile
  end

  def create
    @profile = @user.build_profile(profile_params)

    return unprocessable_entity(@profile.errors) unless @profile.save

    render json: @profile, status: :created
  end

  def update
    return unprocessable_entity(@user.profile.errors) unless @user.profile.update(profile_params)

    render json: @user.profile
  end

  private
    def set_user
      @user = User.find_by!(username: params[:user_username])
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :birth_date, :city, :country, :state, :is_private)
    end
end

class ProfilesController < ApplicationController
  before_action :authorize_request, except: :show
  before_action :set_user

  # GET /users/username/profile
  def show
    render json: @user.profile
  end

  # POST /users/username/profile
  def create
    @profile = @user.build_profile(profile_params)

    if @profile.save
      render json: @profile, status: :created, location: @profile
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/username/profile
  def update
    if @user.profile.update(profile_params)
      render json: @user.profile
    else
      render json: @user.profile.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by!(username: params[:user_username])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :birth_date, :city, :country)
    end
end

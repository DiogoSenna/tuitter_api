class TueetsController < ApplicationController
  before_action :set_user
  before_action :set_tueet, only: %i[ show update destroy ]

  def index
    @tueets = @user.tueets.all

    render json: @tueets
  end

  def show
    render json: @tueet
  end

  def create
    @tueet = @user.build_tueet(tueet_params)

    return unprocessable_entity(@tueet.errors) unless @tueet.save

    render json: @tueet, status: :created, location: @tueet
  end

  def update
    return unprocessable_entity(@tueet.errors) unless @tueet.update(tueet_params)

    render json: @tueet
  end

  def destroy
    @tueet.destroy!
  end

  private
    def set_tueet
      @tueet = Tueet.find(params[:id])
    end

    def set_user
      @user = User.find_by!(username: params[:user_username])
    end

    def tueet_params
      params.require(:tueet).permit(:content, :user_id)
    end
end

class TueetsController < ApplicationController
  before_action :authorize_request, only: %i[ create update destroy ]
  before_action :set_user
  before_action :set_tueet, only: %i[ show update destroy ]
  include Authorizable
  authorize_actions only: %i[ update destroy ]

  def index
    @tueets = @user.tueets.all

    render json: @tueets
  end

  def show
    render json: @tueet
  end

  def create
    @tueet = @user.tueets.build(tueet_params)

    return unprocessable_entity(@tueet.errors) unless @tueet.save

    render json: @tueet, status: :created
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
      allowed = %i[content]
      allowed << :parent_id if action_name === 'create'

      params.require(:tueet).permit(*allowed)
    end
end

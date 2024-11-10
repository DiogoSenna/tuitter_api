class RolesController < ApplicationController
  before_action :authorize_request
  before_action :set_role, only: :show

  include Authorizable
  authorize_actions

  def index
    @roles = Role.all

    render json: @roles
  end

  def show
    render json: @role
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name)
    end
end

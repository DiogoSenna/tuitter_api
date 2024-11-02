class RolesController < ApplicationController
  before_action :set_role, only: :show

  # GET /roles
  def index
    @roles = Role.all

    render json: @roles
  end

  # GET /roles/1
  def show
    render json: @role
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_params
      params.require(:role).permit(:name)
    end
end

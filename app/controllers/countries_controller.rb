class CountriesController < ApplicationController
  before_action :set_country, only: %i[show subdivisions]

  def index
    render json: ISO3166::Country.all.map { |c| { code: c.alpha2, name: c.iso_short_name } }
  end

  def show
    render json: @country
  end

  def subdivisions
    subdivisions = ISO3166::Country[@country&.alpha2]&.subdivisions

    render json: subdivisions
  end

  private

  def set_country
    @country = ISO3166::Country[params[:code]]

    render json: { error: "Invalid country code" }, status: :not_found unless @country
  end
end

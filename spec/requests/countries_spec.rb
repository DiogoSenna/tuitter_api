require 'rails_helper'

RSpec.describe "Countries", type: :request do
  describe "GET /countries" do
    it "lists all countries" do
      get countries_path, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).count).to eq(ISO3166::Country.all.count)
    end
  end

  describe "GET /countries/:code" do
    it "shows the country details" do
      get country_path('BR'), as: :json
      data = JSON.parse response.body

      expect(response).to have_http_status(:ok)
      expect(data['data']['alpha2']).to eq(ISO3166::Country['BR'].alpha2)
      expect(data['data']['iso_short_name']).to eq(ISO3166::Country['BR'].iso_short_name)
    end

    it "fails showing an invalid country's details" do
      get country_path('HDASUASDH'), as: :json

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse response.body).to include({ 'error' => 'Invalid country code' })
    end
  end

  describe "GET /countries/:code/subdivisions" do
    it "shows the subdivisions for a country" do
      get country_subdivisions_path('BR'), as: :json
      data = JSON.parse response.body

      expect(response).to have_http_status(:ok)
      expect(data.count).to eq(ISO3166::Country['BR'].subdivisions.count)
      expect(data['RJ']['name']).to eq(ISO3166::Country['BR'].subdivisions['RJ'].name)
      expect(data['RJ']['code']).to eq(ISO3166::Country['BR'].subdivisions['RJ'].code)
    end

    it "fails showing an invalid country's subdivisions" do
      get country_subdivisions_path('HDASUASDH'), as: :json

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse response.body).to include({ 'error' => 'Invalid country code' })
    end
  end
end

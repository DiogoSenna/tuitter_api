require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }

  describe "GET /users/:user_username/profile" do
    it "returns the profile" do
      puts user_profile_path(user.username)
      get user_profile_path(user.username), as: :json
      # binding.pry
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /users/:user_username/profile" do
    it "creates a new profile" do
      expect {
        post user_profile_url(user.username), params: {
          profile: {
            birth_date: profile.birth_date,
            first_name: profile.first_name,
            last_name: profile.last_name,
            city: profile.city,
            country: profile.country
          }
        }, as: :json
      }.to change(Profile, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PATCH /users/:user_username/profile" do
    it "updates the profile" do
      patch user_profile_url(user.username), params: {
        profile: {
          birth_date: profile.birth_date,
          first_name: "NovoNome",
          last_name: profile.last_name,
          city: profile.city,
          country: profile.country
        }
      }, as: :json
      expect(response).to have_http_status(:success)
      expect(profile.reload.first_name).to eq("NovoNome")
    end
  end

  describe "DELETE /users/:user_username/profile" do
    it "destroys the profile" do
      expect {
        delete user_profile_url(user.username), as: :json
      }.to change(Profile, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
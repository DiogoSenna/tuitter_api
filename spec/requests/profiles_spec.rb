require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }

  let(:headers) do
    token = JsonWebToken.encode(user_id: user.id)
    { "Authorization": "Bearer #{token}" }
  end

  describe "GET /users/:user_username/profile" do
    it "returns the profile" do
      create(:profile, user: user)

      get user_profile_path(user.username), headers: headers, as: :json

      expect(Profile.count).to eq(1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /users/:user_username/profile" do
    it "creates a new profile" do
      expect {
        post user_profile_path(user.username), headers: headers, params: {
          profile: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
            city: Faker::Address.city,
            country: Faker::Address.country
          }
        }, as: :json
      }.to change(Profile, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "fails creating profile without required fields" do
      post user_profile_path(user.username), headers: headers, params: {
        profile: {
          city: Faker::Address.city,
          country: Faker::Address.country
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('first_name', 'last_name', 'birth_date')
    end

    it "fails creating profile with nonexistent country" do
      post user_profile_path(user.username), headers: headers, params: {
        profile: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
          city: Faker::Address.city,
          country: 'Lorem Ipsum'
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include('country')
    end
  end

  describe "PATCH /users/:user_username/profile" do
    let(:profile) { create(:profile, user: user) }

    it "updates the profile" do
      patch user_profile_url(user.username), headers: headers, params: {
        profile: {
          first_name: "New Name",
          last_name: profile.last_name,
          birth_date: profile.birth_date,
          city: profile.city,
          country: profile.country
        }
      }, as: :json

      expect(response).to have_http_status(:success)
      expect(profile.reload.first_name).to eq("New Name")
    end
  end
end
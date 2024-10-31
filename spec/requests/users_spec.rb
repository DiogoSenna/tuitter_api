require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user, username: 'disenna') }

  let(:headers) do
    token = JsonWebToken.encode(user_id: user.id)
    { "Authorization": "Bearer #{token}" }
  end

  describe "GET /users" do
    it "returns a list of users" do
      get users_path, headers: headers, as: :json

      expect(response).to have_http_status(:ok)
      expect(User.count).to eq(1)
    end

    it "fails listing users without authentication token" do
      get users_path, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /users/:username" do
    it "returns a user" do
      get user_path(user.username), headers: headers, as: :json
      expect(response).to have_http_status(:ok)
    end

    it "fails returning nonexistent user" do
      get user_path('NonExistentUser999'), headers: headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /users" do
    let!(:password) { Faker::Internet.password(special_characters: true) }

    it "creates a new user" do
      expect {
        post users_path, params: {
          user: {
            username: Faker::Internet.user_name,
            email: Faker::Internet.email,
            password: password,
            password_confirmation: password
          }
        }, as: :json
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "fails creating an already existing user" do
      post users_path, params: {
        user: {
          username: 'disenna',
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse response.body).to include('username' => ['has already been taken'])
    end

    it "fails creating an user with invalid email" do
      post users_path, params: {
        user: {
          username: Faker::Internet.user_name,
          email: 'invalid_email_format',
          password: password,
          password_confirmation: password
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse response.body).to include('email' => ['is invalid'])
    end

    it "fails creating an user when password doesn't match required rules" do
      password = 'password'

      post users_path, params: {
        user: {
          username: Faker::Internet.user_name,
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse response.body).to include('password' => ['must contain at least one uppercase letter, one lowercase letter, one number, and one special character'])
    end

    it "fails creating an user when password confirmation fails" do
      post users_path, params: {
        user: {
          username: Faker::Internet.user_name,
          email: Faker::Internet.email,
          password: password,
          password_confirmation: 'password'
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse response.body).to include('password_confirmation' => ["doesn't match Password"])
    end
  end

  describe "PATCH /users/:username" do
    it "updates an user" do
      username = Faker::Internet.user_name
      email = Faker::Internet.email

      patch user_path(user.username), headers: headers, params: {
        user: {
          username: username,
          email: email,
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(user.reload.username).to eq(username)
      expect(user.reload.email).to eq(email)
    end
  end
end
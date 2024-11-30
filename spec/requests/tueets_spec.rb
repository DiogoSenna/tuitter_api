require 'rails_helper'

RSpec.describe "Tueets", type: :request do
  let(:user) { create(:user) }

  let(:headers) do
    token = JsonWebToken.encode(user_id: user.id)
    { "Authorization": "Bearer #{token}" }
  end

  describe "GET /users/:user_username/tueets" do
    it "returns the user tueets" do
      create_list(:tueet, 3, user: user)

      get user_tueets_path(user.username), as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).count).to eq(3)
      expect(user.tueets.count).to eq(3)
    end

    it "fails returning a nonexistent user tueets" do
      get user_tueets_path('nonexistentuser'), as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /users/:user_username/tueets/:id" do
    it "returns the user's tueet" do
      tueet = create(:tueet, user: user)

      get user_tueet_path(user.username, tueet), as: :json

      response_body = JSON.parse response.body

      expect(response).to have_http_status(:ok)
      expect(response_body['id']).to eq(tueet.id)
      expect(response_body['content']).to eq(tueet.content)
      expect(response_body['user_id']).to eq(tueet.user_id)
    end

    it "fails returning a nonexistent tueet" do
      get user_tueet_path(user.username, 9999999), as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /users/:user_username/tueets" do
    it "creates a new tueet" do
      post user_tueets_path(user.username), headers: headers, params: {
        tueet: {
          content: "Lorem ipsum",
        }
      }, as: :json

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['content']).to eq('Lorem ipsum')
    end

    it "creates a new tueet reply" do
      tueet = create(:tueet, user: user)

      post user_tueets_path(user.username), headers: headers, params: {
        tueet: {
          content: "Lorem ipsum reply",
          parent_id: tueet.id
        }
      }, as: :json

      response_body = JSON.parse response.body

      expect(response).to have_http_status(:created)
      expect(response_body['content']).to eq('Lorem ipsum reply')
      expect(response_body['id']).to eq(tueet.replies.first.id)
      expect(tueet.replies.first.content).to eq("Lorem ipsum reply")
      expect(tueet.replies.count).to eq(1)
    end

    it "fails creating a tueet if not authenticated" do
      post user_tueets_path(user.username), params: {
        tueet: {
          content: "Lorem ipsum",
        }
      }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end

    it "fails creating a tueet without content" do
      post user_tueets_path(user.username), headers: headers, params: {
        tueet: {}
      }, as: :json

      expect(response).to have_http_status(:bad_request)
    end

    it "fails creating a tueet with an empty content" do
      post user_tueets_path(user.username), headers: headers, params: {
        tueet: {
          content: "",
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "fails creating a tueet with more than the maximum allowed length" do
      post user_tueets_path(user.username), headers: headers, params: {
        tueet: {
          content: "a" * 281,
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "creates a tueet with more than 280 characters for a premium user" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::PREMIUM_USER.to_s)

      post user_tueets_path(user.username), headers: headers, params: {
        tueet: {
          content: "a" * 4000,
        }
      }, as: :json

      response_body = JSON.parse response.body

      expect(response).to have_http_status(:created)
      expect(response_body['content']).to eq('a' * 4000)
      expect(response_body['id']).to eq(user.tueets.first.id)
      expect(response_body['user_id']).to eq(user.id)
    end

    it "fails creating a new tueet with more than 4000 characters for a premium user" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::PREMIUM_USER.to_s)

      post user_tueets_path(user.username), headers: headers, params: {
        tueet: {
          content: "a" * 4001,
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /users/:user_username/tueets/:id" do
    it "updates a tueet" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::PREMIUM_USER.to_s)
      tueet = create(:tueet, user: user)

      patch user_tueet_path(user.username, tueet.id), headers: headers, params: {
        tueet: {
          content: "Lorem ipsum",
        }
      }, as: :json

      response_body = JSON.parse response.body

      expect(response).to have_http_status(:ok)
      expect(response_body['content']).to eq('Lorem ipsum')
      expect(response_body['content']).to eq(tueet.reload.content)
    end

    it "updates another user's tueet if user is admin" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::ADMIN.to_s)

      other_user = create(:user)
      tueet = create(:tueet, user: other_user)

      patch user_tueet_path(other_user.username, tueet.id), headers: headers, params: {
        tueet: {
          content: "Lorem ipsum",
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['content']).to eq(tueet.reload.content)
    end

    it "fails updating a tueet when not a premium user" do
      tueet = create(:tueet, user: user)

      patch user_tueet_path(user.username, tueet.id), headers: headers, params: {
        tueet: {
          content: "Lorem ipsum",
        }
      }, as: :json

      expect(response).to have_http_status(:forbidden)
    end

    it "fails updating a tueet without content" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::PREMIUM_USER.to_s)
      tueet = create(:tueet, user: user)

      patch user_tueet_path(user.username, tueet.id), headers: headers, params: {
        tueet: {}
      }, as: :json

      expect(response).to have_http_status(:bad_request)
    end

    it "fails updating a tueet with an empty content" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::PREMIUM_USER.to_s)
      tueet = create(:tueet, user: user)

      patch user_tueet_path(user.username, tueet.id), headers: headers, params: {
        tueet: {
          content: "",
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "fails updating a tueet with more than the maximum allowed length" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::PREMIUM_USER.to_s)
      tueet = create(:tueet, user: user)

      patch user_tueet_path(user.username, tueet.id), headers: headers, params: {
        tueet: {
          content: "a" * 4001,
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "fails updating a nonexistent tueet" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::PREMIUM_USER.to_s)

      patch user_tueet_path(user.username, 99999), headers: headers, params: {
        tueet: {
          content: "Lorem ipsum",
        }
      }, as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "fails updating a tueet if not authenticated" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::PREMIUM_USER.to_s)
      tueet = create(:tueet, user: user)

      patch user_tueet_path(user.username, tueet.id), params: {
        tueet: {
          content: "Lorem ipsum",
        }
      }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /users/:user_username/tueets/:id" do
    it "deletes a tueet" do
      tueet = create(:tueet, user: user)
      count = user.tueets.count

      expect {
        delete user_tueet_path(user.username, tueet.id), headers: headers, as: :json
      }.to change(Tueet, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(user.tueets).not_to include(tueet)
      expect(user.tueets.count).to eq(count - 1)
    end

    it "deletes another user's tueet if user is admin" do
      Rails.application.load_seed
      user.roles << Role.find_by!(name: Roles::ADMIN.to_s)

      another_user = create(:user)
      tueet = create(:tueet, user: another_user)
      count = another_user.tueets.count

      expect {
        delete user_tueet_path(another_user.username, tueet.id), headers: headers, as: :json
      }.to change(Tueet, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(another_user.tueets).not_to include(tueet)
      expect(user.tueets.count).to eq(count - 1)
    end

    it "fails deleting a nonexistent tueet" do
      delete user_tueet_path(user.username, 99999), headers: headers, as: :json

      expect(response).to have_http_status(:not_found)
    end

    it "fails deleting a tueet if not authenticated" do
      tueet = create(:tueet, user: user)

      delete user_tueet_path(user.username, tueet.id), as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  PASSWORD = Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true)
  let(:user) { create(:user, password: PASSWORD) }

  describe 'POST /auth/login' do
    it 'authenticates an user' do
      post '/auth/login', params: {
        username: user.username,
        password: PASSWORD
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('token', 'user')
    end
  end

  describe 'POST /auth/logout' do
    let(:headers) do
      token = JsonWebToken.encode(user_id: user.id)
      { 'Authorization': "Bearer #{token}" }
    end

    it 'logs out the user and tries to access an authentication required route' do
      expect {
        post '/auth/logout', headers: headers, as: :json
      }.to change(BlacklistedToken, :count).by(1)

      get '/users', as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
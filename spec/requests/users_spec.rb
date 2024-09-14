require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  describe "GET /users" do
    it "returns a list of users" do
      get users_path, as: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
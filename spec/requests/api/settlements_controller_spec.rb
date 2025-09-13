require 'rails_helper'

RSpec.describe "Api::Settlements", type: :request do
  describe "POST /create" do
    it "creates a settlement, returns http status :ok" do
      user = create(:user)

      sign_in user

      post api_settlements_path

      expect(response).to have_http_status(:ok)
    end
  end

end



require 'rails_helper'

RSpec.describe "Api::Posts", type: :request do
  describe "GET /generate_advice" do
    it "returns http success" do
      get "/api/posts/generate_advice"
      expect(response).to have_http_status(:success)
    end
  end

end

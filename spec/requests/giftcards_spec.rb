require 'rails_helper'

RSpec.describe "Giftcards", type: :request do
  describe "GET /giftcards" do
    it "works! (now write some real specs)" do
      get giftcards_path
      expect(response).to have_http_status(200)
    end
  end
end

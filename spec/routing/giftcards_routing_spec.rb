require "rails_helper"

RSpec.describe GiftcardsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/giftcards").to route_to("giftcards#index")
    end

    it "routes to #new" do
      expect(:get => "/giftcards/new").to route_to("giftcards#new")
    end

    it "routes to #show" do
      expect(:get => "/giftcards/1").to route_to("giftcards#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/giftcards/1/edit").to route_to("giftcards#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/giftcards").to route_to("giftcards#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/giftcards/1").to route_to("giftcards#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/giftcards/1").to route_to("giftcards#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/giftcards/1").to route_to("giftcards#destroy", :id => "1")
    end

  end
end

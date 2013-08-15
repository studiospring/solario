require "spec_helper"

describe PostcodesController do
  describe "routing" do

    it "routes to #index" do
      get("/postcodes").should route_to("postcodes#index")
    end

    it "routes to #new" do
      get("/postcodes/new").should route_to("postcodes#new")
    end

    it "routes to #show" do
      get("/postcodes/1").should route_to("postcodes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/postcodes/1/edit").should route_to("postcodes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/postcodes").should route_to("postcodes#create")
    end

    it "routes to #update" do
      put("/postcodes/1").should route_to("postcodes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/postcodes/1").should route_to("postcodes#destroy", :id => "1")
    end

  end
end

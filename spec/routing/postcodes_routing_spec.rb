require "spec_helper"

describe PostcodesController do
  describe "routing" do
    it "routes to #index" do
      expect(get("/postcodes")).to route_to("postcodes#index")
    end

    it "routes to #new" do
      expect(get("/postcodes/new")).to route_to("postcodes#new")
    end

    it "routes to #show" do
      expect(get("/postcodes/1")).to route_to("postcodes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/postcodes/1/edit")).to route_to("postcodes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/postcodes")).to route_to("postcodes#create")
    end

    it "routes to #update" do
      expect(put("/postcodes/1")).to route_to("postcodes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/postcodes/1")).to route_to("postcodes#destroy", :id => "1")
    end
  end
end

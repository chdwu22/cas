require "rails_helper"

RSpec.describe TimeslotsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/timeslots").to route_to("timeslots#index")
    end

    it "routes to #new" do
      expect(:get => "/timeslots/new").to route_to("timeslots#new")
    end

    it "routes to #show" do
      expect(:get => "/timeslots/1").to route_to("timeslots#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/timeslots/1/edit").to route_to("timeslots#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/timeslots").to route_to("timeslots#create")
    end

    it "routes to #update" do
      expect(:put => "/timeslots/1").to route_to("timeslots#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/timeslots/1").to route_to("timeslots#destroy", :id => "1")
    end

  end
end

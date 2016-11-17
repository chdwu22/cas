require 'rails_helper'

RSpec.describe "Timeslots", :type => :request do
  describe "GET /timeslots" do
    it "works! (now write some real specs)" do
      get timeslots_path
      expect(response).to have_http_status(200)
    end
  end
end

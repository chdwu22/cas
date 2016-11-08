require 'rails_helper'

RSpec.describe "Buildings", :type => :request do
  describe "GET /buildings" do
    it "works! (now write some real specs)" do
      get buildings_path
      expect(response).to have_http_status(200)
    end
  end
end

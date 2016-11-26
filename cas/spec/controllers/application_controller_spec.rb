require 'spec_helper'
require 'rails_helper'

describe ApplicationController do

  describe "parse_available_time" do
    it "parses string time to array" do
      expect(subject.parse_available_time("MW-800-1000, T-900-1500")).to eq [[["M","W"],800,1000],[["T"],900,1500]]
    end
  end
  
  describe "to_int_time" do
    it "converts array format time to integers" do
      expect(subject.to_int_time([["T","R"],800,900])).to eq([1920, 1980, 4800, 4860])
    end
  end
  
  describe "day_to_int" do
    it "converts day string to integers" do
      expect(subject.day_to_int("m")).to eq(0)
      expect(subject.day_to_int("T")).to eq(1)
      expect(subject.day_to_int("W")).to eq(2)
      expect(subject.day_to_int("r")).to eq(3)
      expect(subject.day_to_int("F")).to eq(4)
      expect(subject.day_to_int("e")).to eq(-1)
    end
  end
  
  describe "include_time" do
    it "should include time 2 in time 1" do
      expect(subject.include_time?([["T","R"],800,900], [["T"],800,900])).to eq(true)
      expect(subject.include_time?([["T"],800,1000], [["T"],800,900])).to eq(true)
      expect(subject.include_time?([["T","R"],800,900], [["F"],800,900])).to eq(false)
      expect(subject.include_time?([["T","R"],800,900], [["T"],800,910])).to eq(false)
    end
  end
  
  

end

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
      expect(subject.include_time?([["M","W","F"],800,2100], [["M","W","F"],800,850])).to eq(true)
    end
  end
  
  describe "helper_subtract" do
    it "subtracts time2 from time1" do
      expect(subject.helper_subtract([4800, 4920], [1980, 2040])).to eq([4800, 4920]) #1
      expect(subject.helper_subtract([1920, 4920], [1980, 2040])).to eq([1920, 1980, 2040, 4920]) #2
      expect(subject.helper_subtract([1920, 2040, 4800, 4920], [1800, 1900])).to eq([1920, 2040, 4800, 4920]) #3
      expect(subject.helper_subtract([1980, 2040], [1980, 2040])).to eq([]) #4
      expect(subject.helper_subtract([1920, 2040, 4800, 4920], [1980, 2040])).to eq([1920, 1980, 4800, 4920]) #5
      expect(subject.helper_subtract([1920, 2040, 4800, 4920], [4800,4860])).to eq([1920,2040,4860,4920]) #6
      expect(subject.helper_subtract([1920,2040,4860,4920], [1920,1980])).to eq([1980,2040,4860,4920]) #7
    end
  end
  
  describe "subtract_time" do
    it "subtracts time2 from time1" do
      expect(subject.subtract_time([["T","R"],800,1000], [["T"],800,900])).to eq([1980,2040,4800,4920])
      expect(subject.subtract_time([["T","R"],800,1000], [["R","T"],800,900])).to eq([1980,2040,4860,4920])
      expect(subject.subtract_time([["T","R"],800,1100], [["R","T"],900,1000])).to eq([1920,1980,2040,2100,4800,4860,4920,4980])
      expect(subject.subtract_time([["T","R","w"],800,1000], [["T","W"],900,1000])).to eq([1920,1980,3360,3420,4800,4920])
      expect(subject.subtract_time([["T","R","w"],800,1000], [["T","W"],900,1000])).to eq([1920,1980,3360,3420,4800,4920])
    end
  end
  
  describe "array_time_helper" do
    it "convert to two integer to an array format time" do
      expect(subject.array_time_helper(1920,1980)).to eq([["T"],800,900])
      expect(subject.array_time_helper(620,980)).to eq([["M"],1020,1620])
      expect(subject.array_time_helper(3360,3420)).to eq([["W"],800,900])
    end
  end
  
  describe "to_array_time" do
    it "convert to integers to array format time" do
      expect(subject.to_array_time([1920,1980,2040,2100,4800,4860,4920,4980])).to eq([[["T","R"],800,900],[["T","R"],1000,1100]])
      expect(subject.to_array_time([1920,1980])).to eq([[["T"],800,900]])
    end
  end
  
  describe "group" do
    it "group days with same times" do
      expect(subject.group([[["T"],800,900],[["T"],1000,1100],[["R"],800,900],[["R"],1000,1100]])).to eq([[["T","R"],800,900],[["T","R"],1000,1100]])
      expect(subject.group([[["T"],800,900],[["T"],1000,1100],[["R"],800,1000],[["R"],1000,1100]])).to eq([[["T"],800,900],[["T","R"],1000,1100],[["R"],800,1000]])
      expect(subject.group([[["T"],800,900],[["W"],1000,1100],[["R"],800,900],[["R"],1000,1100]])).to eq([[["T","R"],800,900],[["W","R"],1000,1100]])
      expect(subject.group([[["T"],800,900],[["R"],800,900],[["R"],1000,1100]])).to eq([[["T","R"],800,900],[["R"],1000,1100]])
      expect(subject.group([[["T"],800,900],[["W"],9000,1100],[["R"],800,1200],[["F"],1000,1500]])).to eq([[["T"],800,900],[["W"],9000,1100],[["R"],800,1200],[["F"],1000,1500]])
    end
  end
  
  describe "subtract_time_group" do
    it "subtract time group" do
      expect(subject.subtract_time_group([[["M","T"], 800, 1200], [["W"], 800, 1000]],[[["M"], 830, 900], [["W"], 800, 900]])).to eq([[["M"], 900, 1200],[["T"],800,1200], [["W"], 900, 1000]])
      expect(subject.subtract_time_group([[["M"], 800, 900], [["W"], 800, 1000]],[[["M"], 800, 900]])).to eq([[["W"], 800, 1000]])
      expect(subject.subtract_time_group([[["M","W","F"], 800, 900], [["T","R"], 900, 1200]],[[["M","W","F"], 800, 850]])).to eq([[["T","R"], 900, 1200]])
    end
  end
  
  describe "get_availability" do
    it "checks whether a room is available during target time" do
      room = Room.new(:number=>"ETB1111", :capacity=>100, :available_time=> "MTWRF-800-2100")
      mtwrf = Timeslot.new(:day=>"MWF", :from_time=>800, :to_time=>850)
      expect(subject.get_availability(room, mtwrf)).to eq(true)
    end
  end
  
  




  

end

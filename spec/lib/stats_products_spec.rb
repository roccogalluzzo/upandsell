require 'spec_helper.rb'

describe Stats::Products do

  describe "when increment day visit counter" do
    it "should return total day visits" do
      s = Stats::Products.new(1)
      s.add_visit
      s.add_visit
      s.add_visit
      s.add_visit
      s.today_visits.should == 4
    end

     it "should return total week visits" do
      s = Stats::Products.new(2)
      s.add_visit
      s.add_visit
      s.add_visit
      s.add_visit
      s.week_visits.should == 4
    end
     it "should return total monthly visits" do
      s = Stats::Products.new(3)
      s.add_visit
      s.add_visit
      s.add_visit
      s.add_visit
      s.month_visits.should == 4
    end
  end
end

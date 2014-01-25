require 'spec_helper.rb'

describe Stats::Products do

  describe "when increment day visit counter" do
    it "should return only today visits" do
      s = Stats::Products.new(1)
      LibStats::Helpers.add_visit(1, 1.days)
      LibStats::Helpers.add_visit(1, 3.days)
      s.add_visit
      s.add_visit
      s.add_visit
      s.visits_last(1.day).should == 4
    end

    it "should return only week visits" do
      s = Stats::Products.new(2)
      LibStats::Helpers.add_visit(2, 3.weeks)
      s.add_visit
      s.add_visit
      s.add_visit
      s.add_visit
      s.visits_last(1.week).should == 4
    end
    it "should only monthly visits" do
      s = Stats::Products.new(3)
      s.add_visit
      s.add_visit
      LibStats::Helpers.add_visit(3, 3.months)
      s.add_visit
      s.add_visit
      s.visits_last(1.month).should == 4
    end

    it "should only specific day visits" do
      s = Stats::Products.new(4)
      s.add_visit
      s.add_visit
      LibStats::Helpers.add_visit(4, 6.days)
      LibStats::Helpers.add_visit(4, 7.days)
      s.add_visit
      s.add_visit
      s.visits(5.days.ago).should == 1
    end
  end

  describe "when increment day sales counter" do
    it "should return only today sales" do
      s = Stats::Products.new(1)
      LibStats::Helpers.add_sale(1, 1.days)
      LibStats::Helpers.add_sale(1, 3.days)
      s.add_sale
      s.add_sale
      s.add_sale
      s.sales_last(1.day).should == 4
    end

    it "should return only week sales" do
      s = Stats::Products.new(2)
      LibStats::Helpers.add_sale(2, 3.weeks)
      s.add_sale
      s.add_sale
      s.add_sale
      s.add_sale
      s.sales_last(1.week).should == 4
    end
    it "should only monthly sales" do
      s = Stats::Products.new(3)
      s.add_sale
      s.add_sale
      LibStats::Helpers.add_sale(3, 3.months)
      s.add_sale
      s.add_sale
      s.sales_last(1.month).should == 4
    end

    it "should only specific day sales" do
      s = Stats::Products.new(4)
      s.add_sale
      s.add_sale
      LibStats::Helpers.add_sale(4, 6.days)
      LibStats::Helpers.add_sale(4, 7.days)
      s.add_sale
      s.add_sale
      s.sales(5.days.ago).should == 1
    end
  end
end

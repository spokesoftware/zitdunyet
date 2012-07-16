require 'spec_helper'

describe "Initialization" do

  context "Assigning the label" do
    it "should accept a String" do
      label = "The Label"
      co = Zitdunyet::Checkoff.new(label, 0) { "nuthin'" }
      co.label.should == label
    end

    it "should reject anything besides a String" do
      label = 1
      expect { Zitdunyet::Checkoff.new(label, 10) { "nuthin'" } }.to raise_error(ArgumentError)
    end
  end

  context "Assigning progress amount" do
    it "should accept Unit" do
      amount = 10.units
      co = Zitdunyet::Checkoff.new("The Label", amount) { "nuthin'" }
      co.units.should == amount.amount
    end

    it "should accept a Percent" do
      amount = 10.percent
      co = Zitdunyet::Checkoff.new("The Label", amount) { "nuthin'" }
      co.percent.should == amount.amount
    end

    it "should treat Numeric as percentage" do
      amount = 10
      co = Zitdunyet::Checkoff.new("The Label", amount) { "nuthin'" }
      co.percent.should == amount
    end

    it "should reject invalid type" do
      amount = "ten"
      expect { Zitdunyet::Checkoff.new("The Label", amount) { "nuthin'" } }.to raise_error(ArgumentError)
    end
  end

  context "Specifying the completion logic" do
    it "should accept an anonymous block" do
      text = "this is a test"
      co = Zitdunyet::Checkoff.new("The Label", 10) { text }
      co.logic.call.should == text
    end

    it "should raise an exception if the block is missing" do
      expect { Zitdunyet::Checkoff.new("The Label", 10) }.to raise_error(ArgumentError)
    end
  end
end

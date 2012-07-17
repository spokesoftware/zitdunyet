require 'spec_helper'

describe "Expressions" do

  before(:each) do
    begin
      Object.send(:remove_const, :Foo)
    rescue
    end
  end

  context "basics" do
    it "should accept a minimal expression" do
      class Test_1
        include Zitdunyet::Completable
        checkoff "Step One", 8.percent do true end
      end
    end
  end

  context "Percentages" do

    it "should reject percentage exceeding 100" do
      expect {
        class Foo
          include Zitdunyet::Completable
          checkoff "Step One", 101.percent do true end
        end
      }.to raise_error(RangeError)
    end

    it "should reject cumulative percentage exceeding 100" do
      expect {
        class Foo
          include Zitdunyet::Completable
          checkoff "Step One", 8.percent do true end
          checkoff "Step Two", 93.percent do true end
        end
      }.to raise_error(RangeError)
    end

    it "should accept percentage exactly 100" do
      class Foo
        include Zitdunyet::Completable
        checkoff "Step One", 100.percent do true end
      end
    end

    it "should accept cumulative percentage exactly 100" do
      class Foo
        include Zitdunyet::Completable
        checkoff "Step One", 8.percent do true end
        checkoff "Step Two", 92.percent do true end
      end
    end
  end

end

require 'spec_helper'

describe "Expressions" do

  context "basics" do
    it "should accept a minimal expression" do
      class Test_1 < Zitdunyet::Completable
        checkoff "Step One", 8.percent do true end
      end
    end

    it "should evaluate true" do
      class Test_2 < Zitdunyet::Completable
        checkoff "Step One", 8.percent do true end
      end

      test_2 = Test_2.new
      test_2.complete?.should be_true
    end

    it "should evaluate false" do
      class Test_3 < Zitdunyet::Completable
        checkoff "Step One", 8.percent do false end
      end

      test_3 = Test_3.new
      test_3.complete?.should be_false
    end
  end

  context "Percentages" do

    it "should reject percentage exceeding 100" do
      expect {
        class Test_4 < Zitdunyet::Completable
          checkoff "Step One", 101.percent do true end
        end
      }.to raise_error(RangeError)
    end

    it "should reject cumulative percentage exceeding 100" do
      expect {
        class Test_5 < Zitdunyet::Completable
          checkoff "Step One", 8.percent do true end
          checkoff "Step Two", 93.percent do true end
        end
      }.to raise_error(RangeError)
    end

    it "should accept percentage exactly 100" do
      class Test_6 < Zitdunyet::Completable
        checkoff "Step One", 100.percent do true end
      end
    end

    it "should accept cumulative percentage exactly 100" do
      class Test_7 < Zitdunyet::Completable
        checkoff "Step One", 8.percent do true end
        checkoff "Step Two", 92.percent do true end
      end
    end
  end

end

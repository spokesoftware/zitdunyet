require 'spec_helper'

describe "Evaluations" do

  before(:each) do
    begin
      Object.send(:remove_const, :Baz)
    rescue
    end
    begin
      Object.send(:remove_const, :Foo)
    rescue
    end
  end

  context "basics" do
    it "should evaluate true" do
      class Foo
        include Zitdunyet::Completable
        checkoff "Step One", 8.percent do true end
      end

      foo = Foo.new
      foo.complete?.should be_true
    end

    it "should evaluate false" do
      class Foo
        include Zitdunyet::Completable
        checkoff "Step One", 8.percent do false end
      end

      foo = Foo.new
      foo.complete?.should be_false
    end
  end

  context "Percentages" do

    it "should evaluate 0 percent when no checkoff items are done" do
      class Foo
        include Zitdunyet::Completable
        checkoff "Step One", 60.percent do false end
        checkoff "Step Two", 40.percent do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 0
    end

    it "should evaluate intermediate percentage when some checkoff items are done" do
      class Foo
        include Zitdunyet::Completable
        checkoff "Step One", 60.percent do true end
        checkoff "Step Two", 40.percent do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 60
    end

    it "should evaluate 100 percent when all checkoff items are done" do
      class Foo
        include Zitdunyet::Completable
        checkoff "Step One", 60.percent do true end
        checkoff "Step Two", 40.percent do true end
      end

      foo = Foo.new
      foo.percent_complete.should == 100
    end
  end

end

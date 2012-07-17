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
        include Zitdunyet::Completeness
        checkoff "Step One", 8.percent do true end
      end

      foo = Foo.new
      foo.complete?.should be_true
    end

    it "should evaluate false" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 8.percent do false end
      end

      foo = Foo.new
      foo.complete?.should be_false
    end
  end

  context "Percentages" do

    it "should evaluate 0 percent when no checkoff items are done" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.percent do false end
        checkoff "Step Two", 40.percent do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 0
    end

    it "should evaluate intermediate percentage when some checkoff items are done" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.percent do true end
        checkoff "Step Two", 40.percent do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 60
    end

    it "should evaluate 100 percent when all checkoff items are done" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.percent do true end
        checkoff "Step Two", 40.percent do true end
      end

      foo = Foo.new
      foo.percent_complete.should == 100
    end

    it "should evaluate fractional percentage when specified" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.5.percent do true end
        checkoff "Step Two", 39.5.percent do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 60.5
    end

    it "should scale the percentage when the specified percentages don't total 100" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 40.percent do true end
        checkoff "Step Two", 40.percent do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 50
    end

    it "should scale the percentage when the specified percentages exceed 100" do
      pending "a decision on how to handle excess percentage"
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.percent do true end
      end

      class Baz < Foo
        include Zitdunyet::Completeness
        checkoff "Step Two", 60.percent do false end
      end

      baz = Baz.new
      baz.percent_complete.should == 50
    end

  end

  context "Units" do

    it "should evaluate 0 percent when no checkoff items are done" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.units do false end
        checkoff "Step Two", 40.units do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 0
    end

    it "should evaluate intermediate percentage when some checkoff items are done" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.units do true end
        checkoff "Step Two", 40.units do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 60
    end

    it "should evaluate 100 percent when all checkoff items are done" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.units do true end
        checkoff "Step Two", 40.units do true end
      end

      foo = Foo.new
      foo.percent_complete.should == 100
    end

    it "should evaluate to fractional percents when required" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 1.units do true end
        checkoff "Step Two", 199.units do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 0.5
    end
  end

  context "Mix of Percent and Units" do

    it "should evaluate 0 percent when no checkoff items are done" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.percent do false end
        checkoff "Step Two", 40.units do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 0
    end

    it "should evaluate intermediate percentage when some checkoff items are done" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.percent do true end
        checkoff "Step Two", 40.units do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 60
    end

    it "should evaluate scale the units to fit remaining percentage" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.units do true end
        checkoff "Step Two", 40.percent do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 60
    end

    it "should evaluate 100 percent when all checkoff items are done" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.percent do true end
        checkoff "Step Two", 40.units do true end
      end

      foo = Foo.new
      foo.percent_complete.should == 100
    end

    it "should evaluate to fractional percents when required" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 1.units do true end
        checkoff "Step Two", 1.units do false end
        checkoff "Step Three", 99.percent do false end
      end

      foo = Foo.new
      foo.percent_complete.should == 0.5
    end
  end

  context "Hints" do

    it "should provide a hint and percentage for uncompleted checkoff items" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.units do false end
        checkoff "Step Two", 40.units, hint: "Add a widget" do false end
      end

      foo = Foo.new
      foo.hints.should have(2).items
      one = foo.hints.delete("Step One")
      one.should == 60
      two = foo.hints.delete("Add a widget")
      two.should == 40
    end

    it "should evaluate a hint when it is callable" do
      class Foo
        include Zitdunyet::Completeness
        checkoff "Step One", 60.units, hint: lambda {|s| s.blork} do false end
        checkoff "Step Two", 40.units, hint: lambda {|s| "Add #{5-s.count} widgets"} do false end

        def blork
          "Raise the blork coefficient by 30%"
        end

        def count
          3
        end
      end

      foo = Foo.new
      foo.hints.should have(2).items
      puts foo.hints.inspect
      one = foo.hints.delete("Raise the blork coefficient by 30%")
      one.should == 60
      two = foo.hints.delete("Add 2 widgets")
      two.should == 40
    end

  end

end

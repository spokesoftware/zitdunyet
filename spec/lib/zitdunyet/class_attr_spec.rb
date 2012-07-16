require "spec_helper"

describe "Class Attr" do

  before(:all) do
  end

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

  it "should define class-specific attrs" do
    class Foo
      include Zitdunyet::ClassSpecific

      def add(item)
        self.class.checklist_add item
        self.class.units_add 1
      end

      def chklst
        self.class.checklist
      end

      def dump
        puts "Foo#dump: checklist=#{self.class.checklist}, units=#{self.class.units}"
      end
    end

    foo = Foo.new
    foo.dump
    foo.add("Hello")
    foo.dump
    foo.chklst.should have(1).items

  end

  it "should support inheritance" do
    class Foo
      include Zitdunyet::ClassSpecific

      def add(item)
        self.class.checklist_add item
        self.class.units_add 1
      end

      def chklst
        self.class.checklist
      end

      def units
        self.class.units
      end

      def dump
        puts "Foo#dump: checklist=#{self.class.checklist}, units=#{self.class.units}"
      end
    end

    foo = Foo.new
    foo.dump
    foo.add("Hello")
    foo.dump
    foo.chklst.should have(1).items

    class Baz < Foo
      def dump
        puts "Baz#dump: checklist=#{self.class.checklist}, units=#{self.class.units}"
      end
    end

    baz = Baz.new
    baz.dump
    baz.add("World")
    baz.dump
    baz.chklst.should have(2).items
    baz.units.should == 2

    foo.chklst.should have(1).items
    foo.units.should == 1
  end

  it "should initialize with empty array and zeros" do
    class Foo
      include Zitdunyet::ClassSpecific

      def chklst
        self.class.checklist
      end

      def units
        self.class.units
      end
    end

    foo = Foo.new
    foo.chklst.should be_empty
    foo.chklst.should have(0).items
    foo.units.should == 0
  end
end

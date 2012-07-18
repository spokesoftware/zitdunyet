# Zitdunyet

We're all familiar with social websites where you create an account and then are encouraged to provide information about yourself.  They often have something when you login that announces "Your profile is 55% complete.  Add a photo to reach 70%!" The notion of completeness can be applied to objects of all sort, to processes, and so on.

This gem provides a general solution for expressing and assessing completeness.  It includes:

+ a DSL for expressing the conditions
+ methods to report completeness as True/False or percentage
+ a method to provide hints for completion

## Installation

Add this line to your application's Gemfile:

    gem 'zitdunyet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zitdunyet

## Usage

To use the gem, first require the gem and include the Completeness module into the class for which you want to track completeness.

    require 'zitdunyet'

    class UserAccount
      include Zitdunyet::Completeness

      attr_accessor :name, :birthday, :favorite_color, :friends
      ... etc ...
    end

If you'd rather separate concerns, create a Decorator for your model and include the Completeness module there.

    require 'zitdunyet'

    class UserAccountCompleteness
      include Zitdunyet::Completeness

      def initialize(user_account)
        @user_accout = user_account
      end
      ... etc ...
    end

### Basic use case

I'm reminded of Larry Wall's admonition to make simple things easy and difficult things possible.  In that spirit, let's start with a simple use case.

#### Checkoff items

The conditions for completeness are represented as check-off items.  Check-off items are expressed using the #checkoff class macro.

The arguments are:

+ label - a String or something that evaluates to a String to identify the item
+ amount - how much of the completeness is tied to this item, expressed in percent or units
+ options - hint to encourage completion of this item
+ logic - a block to evaluate that determines if this item is done. The block is passed _self_ and evaluates to _true_/_false_.

Let's start with a simple use case in the context of UserAccount.

    checkoff "Name", 30.percent do |s| s.name end
    checkoff "Birthday", 25.percent do |s| s.birthday end
    checkoff "Favorite Color", 15.percent do |s| not s.favorite_color.nil? end
    checkoff "Friends", 30.percent do |s| s.friends.size >= 3 end

This basically gives credit when name, birthday, and favorite_color have values, and when the user has specified 3 or more friends.  Of course, the details of enforcing good values for these fields (e.g., birthdate is actually a Date, friends is an array) is not shown and is your responsibility, not this gem's.

When writing the checkoff, you may chose to use ()'s and {}'s or break the do ... end over multiple lines if that's more your style.  I adopted the style above because it reads well as a DSL.  Ruby purists may have another opinion.  Any valid Ruby method syntax is fair game, though.

    checkoff("Favorite Color", 15.percent) { |s| s.favorite_color }
    checkoff "Friends", 30.percent do |s|
      s.friends.size >= 3
    end

#### Testing completeness

Instances of the class can be tested for completeness by using instance methods defined in Completeness:

+ #complete? - returns true if all of the check-off items' logic blocks evaluate to true; false otherwise
+ #percent_complete - returns a number 0-100 that represents the sum of percentages associated with check-off items that evaluate to true.  If the percentages specified for all of the check-off items total 100, then the result is a strict sum of the completed check-off items.  If the percentages specified total less than 100, then the returned value is scaled to make up the shortfall.

#### Hints

If your UserAccount happens to be incomplete, it would be nice to know what you need to do to complete it.

+ #hints - returns a hash in which the keys are the labels or hints of the uncompleted steps and the values are the percentages

By using descriptive labels you can give a decent prompt to the user.

    checkoff "Birthday filled in", 25.percent do |s| s.birthday end
    checkoff "At least 3 friends", 30.percent do |s| s.friends.size >= 3 end

Sometimes, though, you may want to be more elaborate in your hinting.  #checkoff accepts an optional argument, :hint, for such situations.  The hint must be a string or a block that evaluates to a String.

    checkoff "Favorite Color", 15.percent, hint: "What's your favorite color?" do |s| s.favorite_color end
    checkoff "Friends", 30.percent, hint: lambda {|s| "Add #{3-s.friends.size} friends"} do |s| s.friends.size >= 3 end

The hint over-rides the label when reported by #hints.

### Advanced Usage

Basic usage is fine for most situations, but sometimes you need a little something extra.

#### Units

Percentages are easy to understand, but have the annoying property of having to total 100.  As noted above, the #percent_complete method is forgiving when your totals fall short, but that may be surprising when you start seeing "43.375% complete" reported when you know all your specified percentages are on the 5's and 10's.  Also, checkoff will squawk at you if you attempt to specify a percentage that puts you over 100.

Instead of percent, the checkoff amount can be expressed in units.  This gives you the freedom to specify relative values at whatever scale you like.  #percent_complete will calculate the percentages for you.

    checkoff "Step 1", 1.unit do |s| s.step_1_done? end
    checkoff "Step 2", 1.unit do |s| s.step_2_done? end
    checkoff "Step 3", 1.unit do |s| s.step_3_done? end

This strategy will allow you to add a "Step 4" down the road without having to rejigger percentage.

#### Mixing Percent and Units

You may mix both percent and units in a series of checkoffs if desired. Let's say you want the user name to always count for 30% regardless of anything else.  You could assign it 30% and assign units to the other items.  #percent_complete will honor the explicit percents and scale the units into whatever remains.

#### Inheritance

Let's say you have a special account that subclasses UserAccount.  You want the special account to have additional steps toward completion.  No problem.  Simply specify the additional checkoff items in the subclass.  When evaluating completion, the checkoff items in the UserAccount will be evaluated along with the checkoff items in the subclass.

In situations where subclassing is a possibility it is good practice to specify the checkoff amounts in units rather than percent.  That way the superclass can be complete relative to itself when instantiated, while allowing the subclass to contribute its share when it is instantiated without blowing the 100% barrier.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

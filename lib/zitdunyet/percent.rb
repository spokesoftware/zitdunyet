module Zitdunyet

  class Percent

    attr_accessor :amount

    def initialize(amount)
      self.amount=amount
    end

  end
end

class Numeric
  def percent
    Zitdunyet::Percent.new(self)
  end
end

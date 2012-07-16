module Zitdunyet

  class Unit

    attr_accessor :amount

    def initialize(amount)
      self.amount=amount
    end

  end
end

class Numeric
  def unit
    Zitdunyet::Unit.new(self)
  end

  alias units unit
end

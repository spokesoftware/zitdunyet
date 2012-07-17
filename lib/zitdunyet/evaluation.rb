module Zitdunyet
  module Evaluation

    def complete?
      self.class.checklist.each { |item| return false unless item.logic.call }
      true
    end

    def percent_complete
      unit_percentage = self.class.units == 0 ? 0 : (100 - self.class.percentage) / self.class.units.to_f
      percentage = 0
      complete = true
      self.class.checklist.each do |item|
        if item.logic.call
          percentage += item.percent ? item.percent : item.units * unit_percentage
        else
          complete = false
        end
      end
      complete ? 100 : percentage
    end

  end
end

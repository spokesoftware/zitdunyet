module Zitdunyet
  module Evaluation

    def complete?
      self.class.checklist.each { |item| return false unless item.logic.call }
      true
    end

    def percent_complete
      completeness = 0
      self.class.checklist.each do |item|
        completeness += item.percent if item.logic.call
      end
      completeness
    end

  end
end

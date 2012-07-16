module Zitdunyet
  class Completable
    #extend Expressions
    #include Evaluation
    include Zitdunyet::ClassSpecific

    def self.checkoff(label, progress_amount, *args, &logic)
      # Create an object to represent the check-off item
      choff = Checkoff.new(label, progress_amount, *args, &logic)
      checklist_add choff
      percentage_add(choff.percent) if choff.percent
      units_add(choff.units) if choff.units
      raise RangeError.new "Percentage total (#{percentage}) exceeds 100%" if percentage > 100
    end

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

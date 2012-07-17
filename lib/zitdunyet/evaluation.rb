module Zitdunyet
  module Evaluation

    def complete?
      self.class.checklist.each { |item| return false unless item.logic.call(self) }
      true
    end

    def percent_complete
      # Scale the percentages if they don't add up to 100.  When units are part of the mix, scale the units to fit into
      # the percentage slice leftover after totaling the percentages.
      unit_percentage = 0
      pct_percentage = 1
      if self.class.percentage < 100
        unit_percentage = ((100 - self.class.percentage) / self.class.units.to_f) if (self.class.units > 0)
        pct_percentage = (100 / self.class.percentage.to_f) if (self.class.units == 0)
      elsif self.class.percentage > 100
        pct_percentage = (100 / self.class.percentage.to_f) if (self.class.units == 0)
      end

      completed_pct = 0
      completed_units = 0
      complete = true
      @hints = {}
      self.class.checklist.each do |item|
        if item.logic.call(self)
          if item.percent
            completed_pct += item.percent
          else
            completed_units += item.units if item.units
          end
        else
          complete = false
          hint = item.hint || item.label
          @hints[hint] = item.percent ? item.percent * pct_percentage : item.units * unit_percentage
        end
      end
      complete ? 100 : (completed_pct * pct_percentage) + (completed_units * unit_percentage)
    end

    def hints
      percent_complete unless @hints
      hints = {}
      @hints.each_pair do |hint, pct|
        if hint.respond_to? :call
          hints[hint.call(self)] = pct
        else
          hints[hint.to_s] = pct
        end
      end
      hints
    end
  end
end

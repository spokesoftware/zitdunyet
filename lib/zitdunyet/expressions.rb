module Zitdunyet
  module Expressions

    def checkoff(label, progress_amount, *opts, &logic)
      # Create an object to represent the check-off item
      choff = Checkoff.new(label, progress_amount, *opts, &logic)
      checklist_add choff
      percentage_add(choff.percent) if choff.percent
      units_add(choff.units) if choff.units
      raise RangeError.new "Percentage total (#{percentage}) exceeds 100%" if percentage > 100
    end

  end
end

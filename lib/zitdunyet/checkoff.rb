module Zitdunyet
  class Checkoff
    attr_accessor :label, :percent, :units, :logic, :hint, :stale, :after, :every, :period

    def initialize(label, progress_amount, *opts, &logic)
      (label.is_a? String) ? self.label = label : (raise ArgumentError.new "Label must be a String")
      assign_progress(progress_amount)
      block_given? ? self.logic = logic : (raise ArgumentError.new "Missing the block for assessing completion")
    end

    def assign_progress(progress_amount)
      if progress_amount.is_a? Zitdunyet::Unit
        self.units=progress_amount.amount
      elsif progress_amount.is_a? Zitdunyet::Percent
        self.percent=progress_amount.amount
      elsif progress_amount.is_a? Numeric
        self.percent=progress_amount
      else
        raise ArgumentError.new "Invalid type for progress amount: #{progress_amount.class}"
      end
    end
  end
end

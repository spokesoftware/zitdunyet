module Zitdunyet
  class Checkoff
    attr_accessor :label, :percent, :units, :logic, :hint, :stale, :when

    def initialize(label, progress_amount, *opts, &logic)
      # Fill in the required fields
      (label.is_a? String) ? self.label = label : (raise ArgumentError.new "Label must be a String")
      assign_progress(progress_amount)
      block_given? ? self.logic = logic : (raise ArgumentError.new "Missing the block for assessing completion")

      # Fill in the optional fields if present
      assign_options(opts) unless opts.empty?
    end

    def assign_options(opts)
      options = opts.first
      self.hint = options.delete(:hint)
      #self.stale = options.delete(:stale)
      #self.when = options.delete(:when)
      raise ArgumentError.new "Unrecognized options: #{options.inspect}" unless options.empty?

      #if self.stale or self.when
      #  raise ArgumentError.new "Specified 'stale' without 'when'" unless self.when
      #  raise ArgumentError.new "Specified 'when' without 'stale'" unless self.stale
      #end
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

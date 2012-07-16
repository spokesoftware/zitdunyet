module Zitdunyet
  module ClassSpecific

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

        def checklist
          checklist = self.superclass.respond_to?(:checklist) ? self.superclass.send(:checklist) : []
          @checklist ? checklist + @checklist : checklist
        end

        def checklist_add(item)
          @checklist = (@checklist || []) << item
        end

        def percentage
          percentage = self.superclass.respond_to?(:percentage) ? self.superclass.send(:percentage) : 0
          percentage + (@percentage || 0)
        end

        def percentage=(amount)
          @percentage = amount
        end

        def percentage_add(amount)
          @percentage = (@percentage || 0) + amount
        end

        def units
          units = self.superclass.respond_to?(:units) ? self.superclass.send(:units) : 0
          units + (@units || 0)
        end

        def units=(amount)
          @units = amount
        end

        def units_add(amount)
          @units = (@units || 0) + amount
        end

    end
  end
end

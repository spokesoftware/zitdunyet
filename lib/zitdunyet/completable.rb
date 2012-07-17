module Zitdunyet
  module Completable

    def self.included(base)
      base.extend Zitdunyet::ClassSpecific
      base.extend Zitdunyet::Expressions
    end

    include Zitdunyet::Evaluation

  end
end

module Zitdunyet
  class Completable
    include Zitdunyet::ClassSpecific
    extend Zitdunyet::Expressions
    include Zitdunyet::Evaluation
  end
end

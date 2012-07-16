$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require "zitdunyet"
#require "factory_girl"
#require File.join(File.dirname(__FILE__), "support", "models", "base.rb")
#Dir.glob(File.join(File.dirname(__FILE__), "support", "**", "*.rb")).each {|f| require f}
#
## TODO: (dcp) why isn't the file loading automatically?  should load from spec/factories/*.rb by default.
#Dir.glob(File.join(File.dirname(__FILE__), "factories", "**", "*.rb")).each {|f| require f}

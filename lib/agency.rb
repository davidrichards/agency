$:.unshift File.dirname(__FILE__)
$:.unshift File.dirname(__FILE__) + '/agency'

# Loading the runtime modules
%w(agency_class_methods agency_runtime).each {|file| require file}

# The Agency module:
# * namespaces the code from any other project
# * offers a DSL through its class methods
# * offers a faux singleton (read testable) through its runtime environment
module Agency
  extend AgencyClassMethods
  include AgencyRuntime
end

# Loading the top-level support classes
%w(ext specification element).each {|file| require file}

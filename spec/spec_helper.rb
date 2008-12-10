ENV["AGENCY_ENV"] = "test"
# Some sort of environment
# require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require File.dirname(__FILE__) + "/../lib/agency"
include Agency

require 'spec'

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  config.mock_with :flexmock
  # config.mock_with :rr
end

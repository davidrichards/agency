module Agent #:nodoc:
  class LoadManager
    attr_accessor :target_service_balance
  end
  
  Dir.glob("#{File.dirname(__FILE__)}/load_manager/**/*.rb").each { |file| require file }
  
end
module Agency #:nodoc:
  Dir.glob("#{File.dirname(__FILE__)}/rinda_message_broker/**/*.rb").each { |file| require file }
end
module Agency #:nodoc:
  Dir.glob("#{File.dirname(__FILE__)}/resource/**/*.rb").each { |file| require file }
end

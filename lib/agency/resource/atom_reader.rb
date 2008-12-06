module Agent #:nodoc:
  class AtomReader
    require 'atomutil'

    def initialize(uri)
      @uri = uri
    end
    
    def get_feed(reset=false)
      @atom = nil if reset
      @atom ||= Atom::Feed.new :uri => @uri
      return @atom.to_s
    end
    alias :read :get_feed
  end
end
module Agent #:nodoc:
  
  # To be mixed into an element via the RindaRunner...
  module RindaService
    
    cattr_accessor :tuple_space, :tuple_uri

    # How do I mix this in with another initialize.  I'm not sure...
    def initialize
      require 'rinda/rinda'
      require 'rinda/ring'
      include Rinda
      DRb.start_service
      @tuple_space = RingFinger.primary

      @services = []
    end
    
  end
end
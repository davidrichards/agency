module Agent #:nodoc:
  
  # There needs to be some Rinda-specific code here to start the services and clients and what not here...
  class RindaRunner < Runner
    
    class << self
      
      # Allows the tone of the instance to be set with requires and includes.
      # This is all the central Rinda-based code that needs to be setup once.
      def instance_setup
        require "rinda/tuplespace"
        require "rinda/ring"
        include Rinda

        DRb.start_service

        @@tuple_space = TupleSpace.new
        @@rinda_ring = RingServer.new(@@tuple_space)
        DRb.thread.join
      end
    end
    
  end
end
module Agent #:nodoc:
  class Runner
    
    attr_reader :specification
    def initialize(specification)
      @specification = specification
    end
    
    class << self
      def all_services(n=1)
        # TODO: Define Specification as an extension to Enumerable
        @specification.each {|spec| n.times {spec.start_service} }
      end
      
      def increase(service_name, n=1)
        n.times {@specification[service_name].start_service}
      end
      
      def decrease(service_name, n=1)
        n.times {@specification[service_name].stop_service}
      end
      
    end
  end
end

# Services to run:
# load balancer
# sensors (by type?)
# agent functions (by type?)
# performance evaluators (by type?)
# actuators (by type?)
# knowledge base (if set)
# percept sequence (if set)
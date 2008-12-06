module Agent #:nodoc:
  class Element

    # How/when to move this to RindaRunner???
    
    def initialize(name, &block)
      @name = name
      instance_eval(&block) if block
    end
    
    def start_service
      # Somehow, I'm supposed to have a piece of code that will run as a
      # service...this has to work for Rinda or a different message bus. 
    end
    
    def stop_service
      # Somehow, I'm supposed to have a piece of code that will run as a
      # service...this has to work for Rinda or a different message bus. 
    end
    
    private
      # Needs to be scoped to the encapsulating specification
      def broadcast_on(name, &block)
        self.queues << Queue.new(name)
        instance_eval(&block) if block
      end

      def call_method(method_name)
      end

      # ???
      def emit
      end

      # ???
      def filter(&block)
      end

      def interface(name)
      end

      def listen_on(name)
      end
      alias :listen_to :listen_on

      def listen_with(klass, *args)
      end

      def located_at(uri)
      end

      def persistence_class(klass)
      end

      def repository(name)
      end

      def write_to(name)
      end

      def write_with(klass, *args)
      end
    
  end
end
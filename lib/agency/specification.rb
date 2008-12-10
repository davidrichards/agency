module Agency #:nodoc:
  
  # There are three principal ways to get the runtime environment loaded:
  # a specification (DSL), the configurator (default/initial setup), and
  # the load manager (just adjusts the number of each element running).
  # To store all this in context, there is ResourceCollection.
  # ResourceCollection has class methods that can locate all collections
  # grouped by class, and ResourceCollection speaks to a single class as
  # its defined for a runtime environment. 
  class Specification
  
    attr_accessor :elements
    attr_reader :name
    
    include Enumerable
  
    def initialize(name, &block)
      @name = name
      @queues = @callable_methods = @interfaces = @elements = []
      instance_eval(&block) if block
    end
    
    def blat(&specification)
      instance_eval(&specification)
    end
    
    # The important thing isn't having a specification class full of
    # information, but the runtime environment aware of everything, which
    # happens as a ResourceCollection being updated with the specification.
    # This collection has to be a smart agent, able to fit the LoadManager's
    # specifications by managing duplicates, etc.  Duplicate information
    # ought to be broadcastable to the ResourceCollection regularly without
    # messing up the balance of the runtime. 
    def merge
      # TODO: Send this to the runtime...
    end
  
    def each(&block)
      @elements.each(&block)
    end
  
    def <<(element)
      @elements << element
    end
  
    def [](name)
      @elements[name]
    end
  
    def queue(name)
      @elements << Queue.new(name, &block)
    end

    def sensor(name, &block)
      @elements << Sensor.new(name, &block)
    end

    def percept_sequence(name, &block)
      @elements << PerceptSequence.new(name, &block)
    end
    
    def knowlege_base(name, &block)
      @elements << KnowledgeBase.new(name, &block)
    end

    def agent_function(&block)
      @elements << AgentFunction.new(name, &block)
    end

    def performance_evaluator(&block)
      @elements << PerformanceEvaluator.new(name, &block)
    end

    def actuator(name, &block)
      @elements << Actuator.new(name, &block)
    end
      
  end
end

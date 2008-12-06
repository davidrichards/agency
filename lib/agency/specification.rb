module Agent #:nodoc:

# Do I make each element generic?  I can do that.  How do I want to initialize each one?  Because this part is handled by the runtime configuration piece: how many, up and down.  I can put it in an Element...  I need to know that I can override any part of the specification when I come back later and modify it...  
  class Specification
    
    attr_accessor :queues, :callable_methods, :interfaces, :elements
    
    def initialize(name, &block)
      @name = name
      @queues = @callable_methods = @interfaces = []
      @elements = {}
      instance_eval(&block) if block
    end
    
    def each(&block)
      @elements.each(&block)
    end
    
    def <<(element)
      @elements[element.name] = element
    end
    
    def [](name)
      @elements[name]
    end
    
    def stream(name, &block)
      fullname = "source_" + name.to_s
      element = Source.new(name, &block)
      @elements[fullname] = @sources[fullname] = element
    end
    alias :file :stream
    alias :repository :stream

    def queue(name)
      fullname = "queue_" + name.to_s
      element = Queue.new(name, &block)
      @elements[fullname] = @queues[fullname] = element
    end

    def sensor(name, &block)
      fullname = "sensor_" + name.to_s
      element = Sensor.new(name, &block)
      @elements[fullname] = @sensors[fullname] = element
    end

    def data_store(name, &block)
      fullname = "data_store_" + name.to_s
      element = DataRepository.new(name, &block)
      @elements[fullname] = @data_stores[fullname] = element
    end

    def agent_function(&block)
      fullname = "agent_function_" + name.to_s
      element = AgentFunction.new(name, &block)
      @elements[fullname] = @agent_functions[fullname] = element
    end

    def performance_evaluator(&block)
      fullname = "performance_evaluator_" + name.to_s
      element = PerformanceEvaluator.new(name, &block)
      @elements[fullname] = @performance_evaluators[fullname] = element
    end

    def actuator(name, &block)
      fullname = "actuator_" + name.to_s
      element = Actuator.new(name, &block)
      @elements[fullname] = @actuators[fullname] = element
    end
        
  end
end

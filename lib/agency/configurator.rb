module Agent #:nodoc:
  class Configurator
    def run(&block)
      Agent::Environment.config(&block)
    end
  end
end

module Agent #:nodoc:
  class RindaMessageBroker; end
  class ActiveMQMessageBroker; end
end

module Agent #:nodoc:
  class Environment
    class << self
      
      def instance
        @@inst ||= new
      end
      
      def config(&block)
        begin
          instance_eval(&block)
        ensure
          minimal_setup
        end
      end
      
      # A series of validations that look for inconsistencies in the runtime
      # environment. 
      def minimal_setup
        raise NotImplemented
      end
      
      def log_file
        @@log_file ||= $stderr
      end
      
      def log_file=(loc)
        @@log_file = loc
      end
      
      def logger
        @@logger ||= Logger
      end
      
      def logger=(l)
        @@logger = l
      end
      
      def message_broker
        @@message_broker ||= RindaMessageBroker
      end
      
      def message_broker=(mb)
        @@message_broker = mb
      end
      
      def knowledge_base
        @@knowledge_base ||= CouchKnowledgeBase
      end
      
      def knowledge_base=(kb)
        @@knowledge_base = kb
      end
      
      def queue
        @@queue ||= BoundedQueue
      end
      
      def queue=(qc)
        @@queue = qc
      end
      
      def load_manager
        @@load_manager ||= StaticLoadManager
      end
      
      def load_manager=(lm)
        @@load_manager = lm
      end
      
    end
    
    # Should check that we have a workable static or beginning load definition.
    def ensure_load_configuration
      raise NotImplemented
    end
    
    def load_configuration
      LoadConfiguration
    end
  end
  
  # Used for initial or static load configuration.  These configurations
  # are very similar to each other, and could probably use some DRYness to
  # keep them fresh.  But, they are a little interesting.  I may choose to
  # add new agent functions to manage scaling issues, but I may choose to
  # add new sensors to handle either scale or different kinds of sensors.
  # We are assuming that if something is of the same class then it acts
  # identically to other items of the same class.  The DSL and this
  # configuration simply don't know the difference.  That doesn't mean
  # each one is identical.  They may be performing on different machines,
  # say, or be tuned to work a little differently. 
  class LoadConfiguration
    class << self
      
      raise NotImplemented
      
      def sensors
        @@sensors ||= ResourceCollection.new(:sensors)
      end
      
      def add_sensor(item)
        sensors << item
      end
      
      def remove_sensor(item)
        sensors.remove_resource(item)
      end

      def agent_functions
        @@sensors ||= ResourceCollection.new(:agent_functions)
      end
      
      def add_agent_function(item)
        agent_functions << item
      end
      
      def remove_agent_function(item)
        agent_functions.remove_resource(item)
      end

      def performance_evaluators
        @@performance_evaluators ||= ResourceCollection.new(:performance_evaluators)
      end
      
      def add_performance_evaluator(item)
        performance_evaluators << item
      end
      
      def remove_performance_evaluator(item)
        performance_evaluators.remove_resource(item)
      end
      
      def knowledge_bases
        @@knowledge_bases ||= ResourceCollection.new(:knowledge_bases)
      end
      
      def add_knowledge_base(item)
        knowledge_bases << item
      end
      
      def remove_knowledge_base(item)
        knowledge_bases.remove_resource(item)
      end
      
      def percept_sequences
        @@percept_sequences ||= ResourceCollection.new(:percept_sequences)
      end
      
      def add_percept_sequence(item)
        percept_sequences << item
      end
      
      def remove_percept_sequence(item)
        percept_sequences.remove_resource(item)
      end
      
      def actuators
        @@actuators ||= ResourceCollection.new(:actuators)
      end
      
      def add_actuator(item)
        actuators << item
      end
      
      def remove_actuator(item)
        actuators.remove_resource(item)
      end
      
    end
  end
  
  # This is a named collection of the same type (purpose) of resources,
  # such as :actuators, :knowledge_bases, or :sensors 
  class ResourceGroups
      include Enumerable
      
      def initialize(name, *items)
        @name = name
        @items = {}
        items.each do |item|
          @items[item.class] ||= ResourceCollection.new
          @items[item.class].add_resource(item)
        end
      end

      def each
        @items.each { |key, item| yield key, item }
      end

      # Generically, the classes inspect value will have to be the sortable value.
      def <=>(other)
        self.inspect <=> other.inspect
      end

      def <<(item, &block)
        @items[item.class] ||= ResourceCollection.new
        @items[item.class].add_resource(item, &block)
      end
      alias :add_resource :<<
      
      def remove_resource(item_type, &block)
        @items[item_type].remove_resource(&block) rescue nil
      end

      def collection_type
        @items.first.class
      end

      def confirm_class(new_item)
        return true if collection_type == NilClass
        new_item.class == collection_type
      end
      private :confirm_class
    end
  end
  
  # This is a collection of the same type (class) of resources.
  class ResourceCollection
    include Enumerable
    
    def initialize(*items)
      raise ArgumentError, "You may only collect items of the same class in a ResourceCollection." unless
        items.map {|item| item.class}.uniq.size <= 1
        
      @items = items || []
    end
    
    def each
      @items.each { |item| yield item }
    end
    
    # Generically, the classes inspect value will have to be the sortable value.
    def <=>(other)
      self.inspect <=> other.inspect
    end
    
    # For now, containt the startup command in a block
    def <<(new_item, &block)
      raise ArgumentError, "You may only collect items of the same class in a ResourceCollection." unless confirm_class(new_item)
      @items << new_item
      yield new_item if block
    end
    alias :add_resource :<<
    
    # For now, contain the shutdown command in a block
    def remove_resource(&block)
      removed_item = @items.shift
      yield removed_item if block
    end
    
    def collection_type
      @items.first.class
    end
    
    def confirm_class(new_item)
      return true if collection_type == NilClass
      new_item.class == collection_type
    end
    private :confirm_class
  end
end

require 'logger'
AGENT_ROOT = File.expand_path(File.dirname(__FILE__), '..')

Agent::Configurator.run do |config|
  
  # The default log location is "#{AGENT_ROOT}/log/agent.log"
  # config.log_file = "#{AGENT_ROOT}/log/agent.log"
  
  # The default logger is the Ruby logger
  #config.logger = Logger
  
  # config.message_broker = RindaMessageBroker
  # config.knowledge_base = CouchKnowledgeBase
  # config.queue = BoundedQueue
  # config.load_manager = StaticLoadManager
  # config.load_configuration.add_sensor(SomeClass.new(whatever it needs, possibly node info???))
  
end
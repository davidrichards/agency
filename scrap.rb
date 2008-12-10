# TODO:
# move Rinda stuff into a command, make default
# add a config file and use that to override anything I'm working on
# finish the ideas on the queues
# setup a place to keep commands
# break everything out into the right files in lib



class AddQueueCommand
	include Command
	
	def initialize(opts={})
	  @name = opts.delete(:name)
	  init(opts)
  end
  
  def this_execute
    Environment.instance.add_queue(@name, BoundedQueue)
  end
  
  def this_undo
    Environment.instance.remove_queue(@name)
  end
end

class AddWatchdogQueueCommand
	include Command
end

class AddObservableCommand
  include Command
end


class BoundedQueue
  def initialize(ts, name)
    @ts, @name = ts, name
  end

  SIZE, LENGTH, FULL, EMPTY = (2..5).to_a

  def init(size)
    @ts.write [:bqueue, :tail, @name, 0]
    @ts.write [:bqueue, :head, @name, 1]
    length = 0
    full = false
    empty = true
    @ts.write [:bqueue, :status, size, length, full, empty]
  end

  class << self
    def create(ts, name, size)
      result = new(ts, name)
      result.init(size)
      result
    end

    alias_method :find, :new
  end

  def send(data)
    # read unless queue is full
    status = @ts.take [:bqueue, :status, nil, nil, false, nil]

    # update status
    status[LENGTH] += 1
    status[FULL] = status[SIZE] == status[LENGTH]
    status[EMPTY] = status[LENGTH] == 0

    tail = @ts.take [:bqueue, :tail, @name, nil]
    tail[3] += 1

    @ts.write status
    @ts.write [:bqueue, @name, tail[3], data]
    @ts.write tail
  end

  def read
    # read unless queue is empty
    status = @ts.take [:bqueue, :status, nil, nil, nil, false]

    # update status
    status[LENGTH] -= 1
    status[FULL] = status[SIZE] == status[LENGTH]
    status[EMPTY] = status[LENGTH] == 0

    head = @ts.take [:bqueue, :head, @name, nil]
    t = @ts.take [:bqueue, @name, head[3], nil]
    head[3] += 1

    @ts.write status
    @ts.write head

    t[3]
  end

  def each
    loop do
      yield read
    end
  end
end


class Queue

	def initialize
  end

	def take
	end
	
	def write
	end
	
end

# Instead of take, it reads from the queue and puts a time-sensitive
# "lock" on the tuple in a secondary queue.  On completion of the
# execution, both records are taken from their queues.  If the client
# job takes too long, the lock expires, and another client is free to
# take the record and work on it. 
class WatchdogQueue < Queue
end

class RuntimeEnvironment
  
  include Rinda
  
  class << self
    
    # A quasi-singleton that is easier to test
    def instance
      @@inst ||= new
    end

    # A configurable logger file
    def logger_file=(loc=$stderr)
      require 'logger'
      @@logger = Logger.new(loc)
    end
  end
  
  attr_reader :ts, :ring
  
  def initialize
    
    @queues = @resources = {}
    
    DRb.start_service

    @ts = TupleSpace.new
    @ring = RingServer.new(@ts)
    DRb.thread.join
  end

  def log(level, error)
    @@logger.send(level, error)
  end
  
  def logger; @@logger end
  
  def add_queue(name, klass=BoundedQueue)
    @queues[name] ||= klass.new(@ts, name)
  end
  
  def remove_queue(name)
    @queues.delete(name)
  end
  
  def add_resource(name, klass, *args, &block)
    @resources[name] = klass.new(*args, &block)
  end
  
  def remove_resource(name)
    @resources.delete(name)
  end
end

module Client
  include Rinda
  
  attr_reader :ts
  
  def initialize
    DRb.thread.join
    @ts = RingFinger.primary
  end
end

# Init.rb

require "rinda/tuplespace"
require "rinda/ring"


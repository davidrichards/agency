module Agency #:nodoc:
  module Command

    def initialize(opts={})
      @subcommands = opts[:subcommands] || []
    end
    alias :init :initialize

    def execute
      begin
        @subcommands.each {|command| commands.send(:execute)}
        this_execute
      rescue
        force_undo
      end
    end

    def this_execute
      raise NotImplemented
    end
    private :this_execute

    def undo
      this_undo
      @subcommands.reverse_each {|command| command.send(:undo)}
    end

    # Undo as much as possible, log any errors along the way.
    def force_undo
      begin
        this_undo
      rescue Exception => e
        Environment.instance.logger.error(e)
      end
      @subcommands.reverse_each do |command|
        begin
          command.send(:undo)
        rescue Exception => e
          Environment.instance.logger.error(e)
        end
      end
    end

    def this_undo
      raise NotImplemented
    end
    private :this_undo
  end
  
end

Dir.glob("#{File.dirname(__FILE__)}/command/**/*.rb").each { |file| require file }

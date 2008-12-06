module Agent #:nodoc:
  class StaticLoadManager < LoadManager
    def initialize
      # Makes sure the environment.rb file provided us with a workable static load
      Environment.instance.ensure_load_configuration
    end
  end
end
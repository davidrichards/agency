module Agent
  
  @@specifications = standard_specification
  
  class << self
    
    def specify(name = :default, meta = {:meta => {}}, &specification)
      if @@specifications[name]
        @@specifications[name].blat(meta[:meta], &specification)
      else
        @@specifications[name] = Specification.new(meta[:meta], &specification)
      end
    end
    
    def instance
      @@inst ||= Instance.new(:runner => RindaRunner, :load_balancer => StaticLoad)
    end
    
    def run
      
    end
    
    
    def reset!
      @@specifications = standard_specification
    end
    
    def new(name = :default, args = {})
      specifications[name].to_instance(args[:reconstitute_at])
    end
    
    def reconstitute(reconstitute_at = nil, name = :default)
      specifications[name].to_instance(reconstitute_at)
    end
    
    def standard_specification
    end

  end

end

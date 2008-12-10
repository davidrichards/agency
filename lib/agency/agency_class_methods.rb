module Agency #:nodoc:
  module AgencyClassMethods
    
    @@specifications = {}

    # A safe cattr_reader
    def specifications
      @@specifications
    end

    # This is the DSL, accessible through the specify method and the
    # Specification class. 
    def specify(name=:default, &specification)
      if @@specifications[name]
        @@specifications[name].blat(&specification)
        @@specifications[name]
      else
        @@specifications[name] = Specification.new(name, &specification)
      end
    end
    
  end
end
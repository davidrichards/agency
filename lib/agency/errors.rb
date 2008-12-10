module Agency #:nodoc:
  # The base class for all Agency-specific errors.
  class AgencyError < StandardError; end

  # Setup in the context_set class in strategy patterns
  class NotImplemented < AgencyError; end

  # Raised to denote a condition that should never occur. If this gets
  # raised, it is the Agency's fault, not the consumer's.
  class Bug < AgencyError; end
  
end
# An effort to keep ActiveSupport minimal here.
class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end
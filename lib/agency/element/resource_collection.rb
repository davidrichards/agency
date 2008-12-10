module Agency #:nodoc:
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

# Need to move resource group stuff to class methods....
# module Agency #:nodoc:
#   # This is a named collection of the same type (purpose) of resources,
#   # such as :actuators, :knowledge_bases, or :sensors 
#   class ResourceGroups
#     include Enumerable
# 
#     def initialize(name, *items)
#       @name = name
#       @items = {}
#       items.each do |item|
#         @items[item.class] ||= ResourceCollection.new
#         @items[item.class].add_resource(item)
#       end
#     end
# 
#     def each
#       @items.each { |key, item| yield key, item }
#     end
# 
#     # Generically, the classes inspect value will have to be the sortable value.
#     def <=>(other)
#       self.inspect <=> other.inspect
#     end
# 
#     def <<(item, &block)
#       @items[item.class] ||= ResourceCollection.new
#       @items[item.class].add_resource(item, &block)
#     end
#     alias :add_resource :<<
# 
#     def remove_resource(item_type, &block)
#       @items[item_type].remove_resource(&block) rescue nil
#     end
# 
#     def collection_type
#       @items.first.class
#     end
# 
#     def confirm_class(new_item)
#       return true if collection_type == NilClass
#       new_item.class == collection_type
#     end
#     private :confirm_class
#   end
# 
# end

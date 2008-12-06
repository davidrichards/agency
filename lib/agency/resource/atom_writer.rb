module Agent #:nodoc:
  class AtomWriter
    require 'atomutil'

    def initialize(uri)
      @uri = uri
    end
    
    def post_feed(txt)
      # @atom = Atom::Feed.new
      # @atom ||= Atom::Feed.new :uri => @uri
      # return @atom.to_s
    end
    alias :write :post_feed
  end
end


# auth = Atompub::Auth::Wsse.new :username => 'myname', :password => 'mypass'
# 
# client = Atompub::Client.new :auth => auth
# 
# service = client.get_service( 'http://example/service/api/endpoint' )
# collection = service.workspaces.first.collection.first
# categories = client.get_categories( collection.categories.href )
# 
# categories.categories.each do |category|
#   puts category.label
#   puts category.scheme
#   puts category.term
# end
# 
# feed = client.get_feed( collection.href )
# 
# puts feed.title # 'Example Feed'
# puts feed.icon  # http://example/icon.jpg
# puts feed.logo  # http://example/logo.jpg
# 
# entries = feed.entries
# entries.each do |entry|
#   puts entry.id
#   puts entry.title
# end
# 
# entry = entries.first
# entry.title = 'Changed!'
# 
# client.update_entry( entry.edit_link, entry )
# 
# client.delete_entry( entries[2].edit_link )
# 
# new_entry = Atom::Entry.new
# new_entry.title = 'New!'
# new_entry.summary = 'New Entry for Example'
# new_entry.published = Time.now 
# 
# edit_uri = client.create_entry( collection.href, new_entry )
# 
# # you also can use 'slug'
# slug = 'new entry'
# edit_uri = client.create_entry( collection.href, new_entry, slug )
# 
# media_collection = service.workspaces.first.collections[1]
# media_collection_uri = media_collection.href
# 
# media_uri = client.create_media( media_collection_uri, 'foo.jpg', 'image/jpeg')
# # with slug
# # client.create_media( media_collection_uri, 'foo.jpg', 'image/jpeg', 'new-image') 
# 
# media_entry = client.get_entry( media_uri )
# edit_media_link = media_entry.edit_media_link
# client.update_media( edit_media_link, 'bar.jpg', 'image/jpeg' )
# client.delete_media( edit_media_link )
# 
# feed_contains_media_entreis = client.get_feed( media_collection_uri )

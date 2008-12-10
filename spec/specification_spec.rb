require File.dirname(__FILE__) + "/spec_helper"

describe Specification, "initialize" do
  
  it "should take a name" do
    Specification.new('name').name.should eql('name')
  end
  
  it "should take a block" do
    @s = Specification.new('name') { |s| s.elements << 1 }
    @s.elements.should eql([1])
  end
end

describe Specification, "blat" do
  before(:each) do
    @s = Specification.new('name')
  end
  
  it "should extend the current implementation through blat" do
    @s.elements.should eql([])
    @s.blat { |s| s.elements << 1}
    @s.elements.should eql([1])
  end
end

describe Specification, "each" do
  it "should implement each to iterate the elements in the class." do
    # Not a typical use of the intializer.
    @s = Specification.new('name') {|s| s.elements = [1,2,3] }
    @a = []
    @s.elements.each {|x| @a << x ** 2}
    @a.should eql([1, 4, 9])
  end
end

describe Specification, "<<" do
  it "should append to elements with <<" do
    @s = Specification.new('name') {|s| s.elements = [1,2,3] }
    @s << 4
    @s.elements.should eql([1,2,3,4])
  end
end

describe Specification, "[]" do
  it "should index the elements of the class" do
    @s = Specification.new('name') {|s| s.elements = [1,2,3] }
    @s[0].should eql(1)
  end
end

describe Specification, "queue" do
  # I don't know what problems/solutions I'm dealing with...elements in
  # the spec or in the agent?  Do need to use the ResourceCollection and
  # ResourceGroups 
end
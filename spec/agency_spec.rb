require File.dirname(__FILE__) + "/spec_helper"

describe Agency, "specify" do
  
  before(:each) do
    @specification = flexmock(Specification, :blat => self, :name => :name)
    class Specification; def new; @specification; end; end
  end
  
  it "should have a specify method to specify a new agency runtime." do
    Agency.should be_respond_to(:specify)
  end
  
  it "should take an optional name as a parameter to specify." do
    Agency.specify(:name).name.should eql(:name)
  end

  it "should be able to define a specification from a block" do
    lambda{Agency.specify do; end}.should_not raise_error
  end
  
  it "should be able to re-define a specification" do
    s = Agency.specify(:my_other_name)
    Agency.specify(:my_other_name) do; end
    Agency.specifications[:my_other_name].should eql(s)
  end
end
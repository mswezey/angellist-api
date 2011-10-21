require 'spec_helper'

describe AngellistApi::Authentication do
  class BasicClass
    include AngellistApi::Authentication
  end
  
  class FullClass
    include AngellistApi::Authentication
    attr_accessor :consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret
  end

  describe "#authentication" do
    context "without auth variables defined" do
      it "should return a hash with nil values" do
        a = BasicClass.new
        a.send(:authentication).values.any?.should be_false
      end
    end
    
    context "with auth variables defined" do
      before(:each) do
        @a = FullClass.new
      end
      
      it "should return a hash with nil values if auth variables are not set" do
        @a.send(:authentication).values.all?.should be_false
      end

      it "should return a hash with nil values if auth variables are set" do
        @a.consumer_key = "key"
        @a.consumer_secret = "secret"
        @a.oauth_token = "token"
        @a.oauth_token_secret = "token_secret"
        @a.send(:authentication).values.all?.should be_true
      end
    end
  end
  
  describe "#authenticated?" do
    before(:each) do
      @a = FullClass.new
    end
    
    it "should return false if authentication has all nil values" do
      @a.expects(:authentication).returns({:consumer_key=>nil, :consumer_secret=>nil, :oauth_token=>nil, :oauth_token_secret=>nil})
      @a.send(:authenticated?).should be_false
    end
    
    it "should return false if authentication has any nil values" do
      @a.expects(:authentication).returns({:consumer_key=>nil, :consumer_secret=>"2", :oauth_token=>"3", :oauth_token_secret=>"4"})
      @a.send(:authenticated?).should be_false
    end
    
    it "should return true if authentication has no nil values" do
      @a.expects(:authentication).returns({:consumer_key=>"1", :consumer_secret=>"2", :oauth_token=>"3", :oauth_token_secret=>"4"})
      @a.send(:authenticated?).should be_true
    end
  end

end
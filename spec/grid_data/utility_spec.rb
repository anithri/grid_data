require "spec_helper"

describe GridData::Utility do

  describe "#fill_with_col_name" do
    it "should use defaults when no other config is present" do
      result = GridData::Utility.fill_with_col_name(my_orig_hash)
      result[:foo][:name].should  == 'foo'
      result[:bar][:name].should  == 'bar'
      result[:foo][:index].should == 'foo'
      result[:bar][:index].should == 'bar'
    end

    it "should use the GridData.config.auto_keys entry if it exists." do
      GridData.config.auto_keys = [:alpha, :beta]
      result = GridData::Utility.fill_with_col_name(my_orig_hash)
      result[:foo][:alpha].should == 'foo'
      result[:bar][:alpha].should == 'bar'
      result[:foo][:beta].should  == 'foo'
      result[:bar][:beta].should  == 'bar'
    end

    it "should use the values passed as second param" do
      GridData.config.auto_keys = nil
      result = GridData::Utility.fill_with_col_name(my_orig_hash,[:gamma, :delta])
      result[:foo][:gamma].should == 'foo'
      result[:bar][:gamma].should == 'bar'
      result[:foo][:delta].should == 'foo'
      result[:bar][:delta].should == 'bar'
    end

  end
end

def my_orig_hash
  {foo:{a:1,b:2}, bar:{c:3,d:4}}
end
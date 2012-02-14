require "spec_helper"

describe GridData::Strategies::ActiveRecord do

  describe "#appiles_to_model?" do
    it "should return nil when given something besides an ActiveRecord model" do
      subject.applies_to_model?(nil).should be_nil
    end
    it "should return GridData::Strategy::ActiveRecord for a given active_record model" do
      subject.applies_to_model?(TestStuff).should be subject
    end
  end

  describe "#table_name(model)" do
    it "should return the correct name of the table the model persists." do
      subject.table_name(TestStuff).should == "test_stuff"
    end
  end

  describe "#humanized_col_name(model, col)" do
    it "should return the correct name for the given model and column" do
      subject.humanized_col_name(TestStuff,:id).should == "Ident"
      subject.humanized_col_name(TestStuff,:name_of_non_existant_col).should == "Name of non existant col"
    end
  end

  describe "#do_filter(chain, filters)" do
    it "should return a chain of where filters" do
      result = subject.do_filter(Stuff, {'rules' => []})
      warn result.inspect
    end
  end

end



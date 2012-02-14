require "spec_helper"

describe GridData::Strategies::ActiveRecord do

  before(:each) {TestStuff.scrub_values_for_test}

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
      filters = {"groupOp"=>"AND", "rules"=>[
          {"field"=>"color", "op"=>"bw", "data"=>"green"},
          {"field"=>"name",  "op"=>"bw", "data"=>"thomas"}
      ]}
      result = subject.do_filter(TestStuff, filters)
      #result.should be_a_kind_of(ActiveRecord::Relation)
      result.where_values.length.should == 2
      result.where_values[0].should == ["color LIKE ?",'%green%']
      result.where_values[1].should == ["name LIKE ?",'%thomas%']
    end
  end

  describe "#do_sort(chain, index, order)" do
    context "for a simple sort index" do
      it "should return a chain containing an order" do
        result = subject.do_sort(TestStuff, "birthday", "DESC")
        result.order_values.length.should == 1
        result.order_values[0].should == "birthday DESC"
      end
    end

    context "for a complex sort index" do
      it "should return a chain containing an order" do
        result = subject.do_sort(TestStuff, "color, name", "ASC")
        result.order_values.length.should == 1
        result.order_values[0].should == "color ASC, name ASC"
      end
    end

  end


end



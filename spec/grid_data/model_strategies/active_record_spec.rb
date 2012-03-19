require "spec_helper"

describe GridData::ModelStrategies::ActiveRecord do
  subject{GridData::ModelStrategies::ActiveRecord}

  describe "#init(model)" do
    it "should check the model for compliance and return what is passed to it" do
      subject.init(Color).should == Color
    end

    it "should raise a GridData::ModelError if the model is not an ActiveRecord" do
      lambda{subject.init(:sym)}.should raise_error GridData::ModelError, /does not seem to be/
      lambda{subject.init(Hash)}.should raise_error GridData::ModelError, /does not seem to be/
      lambda{subject.init("hiya")}.should raise_error GridData::ModelError, /does not seem to be/
    end

  end

  describe "#is_active_record?(model)" do
    it "should return true if the model is an activerecord" do
      subject.is_active_record?(Color).should be_true
    end

    it "should return false if the model is not an activerecord" do
      subject.is_active_record?(:sym).should be_false
      subject.is_active_record?(String).should be_false
      subject.is_active_record?(123).should be_false

    end
  end

  describe "#filter(chain, filters)" do
    it "should return itself if filter['rules'] is empty" do
      filter_str = "{\"groupOp\":\"AND\",\"rules\":[]}"
      subject.filter(Color, filter_str ).should == Color
    end
    it "should return itself if filter['rules'] is empty" do
      filter_str = "{\"groupOp\":\"AND\",\"rules\":[{\"field\":\"name\",\"op\":\"bw\",\"data\":\"corp\"},{\"field\":\"country\",\"op\":\"bw\",\"data\":\"us\"}]}"
      result = subject.filter(Color, filter_str )
      result.where_values.length.should == 2

    end
  end

  describe "#sort(chain, sidx, sord)" do
    it "should set order_values on chain" do
      subject.sort(Color,"name",nil).order_values.should == ["name "]
    end
  end
end

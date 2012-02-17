require "spec_helper"

describe GridData::Facade do
  subject { GridData::Facade }
  let(:test_facade) do
    Module.new do
      extend self
      extend GridData::Facade
    end
  end

  describe "#grid_data_model" do
    it "should set the @model_strategy with the given object if the object is not a symbol or a string" do
      warn test_facade.inspect
      test_facade.set_model_strategy String
      test_facade.model_strategy.should == String
    end

    
  end

  describe "#grid_data_paginator" do
    pending
  end

  describe "#load_config_file" do
    pending
  end

  describe "#facade_for" do
    pending
  end

end
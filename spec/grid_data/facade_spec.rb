require "spec_helper"

describe GridData::Facade do
  subject { GridData::Facade }
  let(:test_facade) do
    Module.new do
      extend self
      extend GridData::Facade
    end
  end

  describe "mattr_readers" do
    it "should have a method and class variable for each reader" do
      warn test_facade.class_variables.inspect
      test_facade.should respond_to(:model, :model_strategy, :paginator)
    end
  end

  describe "#determine_constant(obj, namespace = '')" do
    it "should return obj if obj is not a kind of string or symbol" do
      test_facade.determine_constant(123).should == 123
      test_facade.determine_constant(String).should == String
    end

    it "should return the class or module that the string or symbol represents" do
      test_facade.determine_constant(:string).should == String
      test_facade.determine_constant("module").should == Module
    end

    it "should return the class or module in a given namespace" do
      test_facade.determine_constant(:facade, "GridData").should == GridData::Facade
      test_facade.determine_constant("inflector","ActiveSupport").should == ActiveSupport::Inflector
    end
  end

  describe "#set_model_strategy(obj)" do
    it "should set the @model_strategy with the given object if the object is not a symbol or a string" do
      test_facade.set_model_strategy String
      test_facade.model_strategy.should == String
      test_facade.set_model_strategy "Array"
      test_facade.model_strategy.should == Array
      test_facade.set_model_strategy :hash
      test_facade.model_strategy.should == Hash
    end
    context "when the string or symbol is a valid name in the context of GridData::ModelStrategies" do
      it "should turn the string or symbol into a Module constant and return it." do
        module GridData; module ModelStrategies; module TestStrategy; end; end; end
        test_facade.set_model_strategy "test_strategy"
        test_facade.model_strategy.should == GridData::ModelStrategies::TestStrategy
        test_facade.set_model_strategy :test_strategy
        test_facade.model_strategy.should == GridData::ModelStrategies::TestStrategy
      end
    end
    it "should raise a GridData::ModelStrategyError if it can find no matching strategy" do
      lambda { test_facade.set_model_strategy nil}.should raise_error(GridData::ModelStrategyError)
      lambda { test_facade.set_model_strategy "foo_bar/baz"}.should raise_error(GridData::ModelStrategyError)
    end

  end

  describe "#set_paginator(obj)" do
    it "should set the @paginator with the given object if the object is not a symbol or a string" do
      test_facade.set_paginator String
      test_facade.paginator.should == String
    end

    describe "should set the @paginator with a string or symbol" do
      context "when the string or symbol is a valid name, use it." do
        it "should turn the string or symbol into a Module constant and return it." do
          test_facade.set_paginator "Array"
          test_facade.paginator.should == Array
          test_facade.set_paginator :hash
          test_facade.paginator.should == Hash

        end
      end
      context "when the string or symbol is a valid name in the context of GridData::Paginators" do
        it "should turn the string or symbol into a Module constant and return it." do
          module GridData; module Paginators; module TestPaginator; end; end; end
          test_facade.set_paginator "test_paginator"
          test_facade.paginator.should == GridData::Paginators::TestPaginator
          test_facade.set_paginator :test_paginator
          test_facade.paginator.should == GridData::Paginators::TestPaginator
        end
      end
      it "should raise a GridData::ModelStrategyError if it can find no matching paginator" do
        lambda { test_facade.set_paginator nil}.should raise_error(GridData::PaginatorError)
        lambda { test_facade.set_paginator "foo_bar/baz"}.should raise_error(GridData::PaginatorError)
      end
    end
  end

  describe "#facade_for" do

    it "should set the @model with the given object if the object is not a symbol or a string" do
      test_facade.facade_for String
      test_facade.model.should == String
    end

    describe "should set the @model with a string or symbol" do
      context "when the string or symbol is a valid name, use it." do
        it "should turn the string or symbol into a Module constant and return it." do
          test_facade.facade_for "Array"
          test_facade.model.should == Array
          test_facade.facade_for :hash
          test_facade.model.should == Hash

        end
      end
      it "should raise a GridData::ModelStrategyError if it can find no matching facade" do
        lambda { test_facade.facade_for nil}.should raise_error(GridData::ModelError)
        lambda { test_facade.facade_for "foo_bar/baz"}.should raise_error(GridData::ModelError)
      end
    end
  end

  describe "#load_config_file" do
    it "should raise an argument error if file_list is empty" do
      lambda{test_facade.load_config_file}.should raise_error ArgumentError, /no files listed/
    end


  end


end

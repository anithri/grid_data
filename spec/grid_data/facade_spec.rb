require "spec_helper"

describe GridData::Facade do
  subject { GridData::Facade }
  let(:test_facade) do
    Module.new do
      extend self
      extend GridData::Facade
    end
  end

  let(:full_facade) do
    Module.new do
      extend self
      extend GridData::Facade
      set_model_strategy "active_record"
      set_paginator "kaminari"
      facade_for
    end
  end

  let(:fake_facade) do |strategy|

  end


  describe "mattr_readers" do
    it "should have a method and class variable for each reader" do
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

  describe "#row_data(params)" do
    it "should return a well formed hash, given just page and per parameters" do
      strategy = double(GridData::ModelStrategies::ActiveRecord)
      strategy.stub(:init).and_return("fake")
      strategy.should_receive(:finalize) { |args| args}
      strategy.should_receive(:total_rows).and_return(17)
      GridData::Paginators::TestPaginator.stub(:page) {|args| args[0]}
      fake_facade = Module.new do
                  extend self
                  extend GridData::Facade
                  set_model_strategy strategy
                  set_paginator :test_paginator
      end

      warn fake_facade.class_variables
      warn fake_facade.constants
      fake_facade.class_variable_set(:@@paginator, nil)
      output = fake_facade.row_data("page" => "2", "per" => "4")
      output.keys.should =~ [:total, :page, :records, :rows]
      output[:total].should == 5
      output[:page].should == 2
      output[:records].should == 17
    end

    it "should return a well formed hash, given page, rows, filters, and order" do
      strategy = double(GridData::ModelStrategies::ActiveRecord)
      strategy.stub(:init).and_return("fake")
      strategy.should_receive(:sort) { |args| args[0]}
      strategy.should_receive(:filter) { |args| args[0]}
      strategy.should_receive(:finalize) { |args| args}
      strategy.should_receive(:total_rows).and_return(17)
      GridData::Paginators::TestPaginator.stub(:page) {|args| args[0]}

      fake_facade = Module.new do
                  extend self
                  extend GridData::Facade
                  set_model_strategy strategy
                  set_paginator :test_paginator
      end
      fake_facade.class_variable_set(:@@paginator, nil)
      output = fake_facade.row_data("page" => "2", "per" => "4", "_search" => "true", "filters" => "something",
                                    "sidx" => "abc", "sord" => "xyz")
      output.keys.should =~ [:total, :page, :records, :rows]
      output[:total].should == 5
      output[:page].should == 2
      output[:records].should == 17
    end
  end


end

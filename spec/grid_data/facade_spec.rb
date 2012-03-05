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
#    specify {true.should be_false}
    it "should set the @model_strategy with the given object if the object is not a symbol or a string" do
      test_facade.set_model_strategy String
      test_facade.model_strategy.should == String
    end

    describe "should set the @model_strategy with a string or symbol" do
      context "when the string or symbol is a valid name, use it." do
        it "should turn the string or symbol into a Module constant and return it." do
          test_facade.set_model_strategy "Array"
          test_facade.model_strategy.should == Array
          test_facade.set_model_strategy :hash
          test_facade.model_strategy.should == Hash

        end
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

  end

  describe "#grid_data_paginator" do
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

  describe "#load_config_file" do

    pending
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

end

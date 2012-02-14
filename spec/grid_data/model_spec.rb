require "spec_helper"

describe GridData::Model do

  before :all do
    GridData.config.registered_strategies = [::GridData::Strategies::ActiveRecord]
  end

  before :each do
    GridData.config.default_paginator = GridData::Paginators::KaminariPaginator
    class TestStuff
      include ::GridData::Model
    end
  end

  context "when included" do
    it "should set a strategy" do
      TestStuff.instance_variable_get(:@grid_data_strategy).should be GridData::Strategies::ActiveRecord
    end

    it "should read it's config file" do
      col_model_array = TestStuff.instance_variable_get(:@grid_data_columns)
      col_model_array.length.should == 2
      col_model_array[:id][:name].should == "id"
      col_model_array[:name][:width].should == 300
    end

    it "should set a paginator" do
      pending
      TestStuff.instance_variable_get(:@grid_data_paginator).should be GridData::Paginators::KaminariPaginator
    end
  end

  describe "#model_grid_yaml_file" do
    it "should return a file like test_stuff_grid.yaml for a table name like test_stuff" do
      TestStuff.model_grid_yaml_file.should == "spec/config/test_stuff_grid.yaml"
    end
  end

  describe "#col_header_names" do
    it "should return an array of humanized names" do
      TestStuff.col_header_names.should == ["Ident", "My Name!"]
    end
  end

  describe "#col_models" do
    it "should return an array of col_models" do
      col_models = TestStuff.col_models
      col_models.should be_a_kind_of(Array)
      col_models.length.should == 2
      col_models[0][:name].should == "id"
      col_models[1][:editrules][:required].should be_true
    end
  end



end
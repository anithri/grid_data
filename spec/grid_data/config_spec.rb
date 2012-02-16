require "rspec"

config_default_yaml = { columns: {name: {width: 300}}}

alternate_yaml = {foo: 123, bar: "baz"}

describe GridData::Config do

  describe "#global_defaults" do
    context "when no global_config file exists" do
      let(:global_defaults) do
        File.stub(:exists?).and_return(false)
        GridData::Config.global_defaults
      end

      it "should return an ActiveSupport::OrderedOptions" do
        GridData::Config.global_defaults.should be_a ActiveSupport::OrderedOptions
      end

      specify {global_defaults.yaml_extension.should == "yaml"}
      specify {global_defaults.loaded_global_config.should be_false}
    end

    context "when a global_config file exists" do
      let(:global_defaults) do
        YAML.stub(:load_file).and_return config_default_yaml
        GridData::Config.global_defaults
      end

      it "should return an ActiveSupport::OrderedOptions" do
        GridData::Config.global_defaults.should be_a ActiveSupport::OrderedOptions
      end

      specify {global_defaults.yaml_extension.should == "yaml"}
      specify {global_defaults.loaded_global_config.should be_true}
      specify {global_defaults.columns.should be_a Hash}
      specify {global_defaults.columns[:name][:width].should == 300}
    end
  end

  describe "#load_global_from_file" do
    context "when passed with no append flag" do

      it "#should replace the existing options with new ones." do
        YAML.stub(:load_file) do |file|
          file == "alternate" ? alternate_yaml : config_default_yaml
        end
        orig_config = GridData::Config.global_defaults
        orig_config.foo.should_not == 300
        orig_config.bar.should_not == "baz"

        GridData.stub(:config).and_return(orig_config)
        config_after = GridData::Config.load_global_from_file("alternate")
        config_after.should_not have_key(:columns)
        config_after.foo.should == 123
        config_after.bar.should == "baz"
      end
    end

    context "when passed with an append flag" do

      it "#should append the new values onto the old" do
        YAML.stub(:load_file) do |file|
          file == "alternate" ? alternate_yaml : config_default_yaml
        end
        orig_config = GridData::Config.global_defaults
        GridData.stub(:config).and_return(orig_config)
        config_after = GridData::Config.load_global_from_file("alternate", :append)
        config_after.should_not have_key(:columns)
        config_after.foo.should == 123
        config_after.bar.should == "baz"
      end
    end
  end
end



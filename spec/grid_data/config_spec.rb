require "rspec"

def config_default_yaml
  {columns: {name: {width: 300}}}
end

def alternate_yaml
  {foo: 123, bar: "baz"}
end

describe GridData::Config do
  subject { GridData::Config }

  describe "#mk_default_config" do
    specify { subject.mk_default_config.should be_a ActiveSupport::OrderedOptions }
  end

  describe "#check_config_file(filename)" do
    context "when DataGrid::Config.on_missing_config_file = :warn" do
      before(:all) do
        subject.on_missing_config_file = :warn
      end

      it "should return false and issue a warning" do
        $VERBOSE = nil
        subject.check_config_file('/GARBAGE/test/123').should be_false
        $VERBOSE = false
      end
      #TODO check for warning?
    end

    context "when DataGrid::Config.on_missing_config_file = :raise" do
      before(:all) {subject.on_missing_config_file = :raise}

      it "should raise GridConfig::ConfigFileError" do
        lambda {subject.check_config_file('/GARBAGE/test/456')}.should raise_error
        (GridData::ConfigFileError)
      end
    end

    context "when DataGrid::Config.on_missing_config_file = :warn" do
      before(:all) {subject.on_missing_config_file = false}
      specify {subject.check_config_file('/GARBAGE/test/789').should be_false}
    end
  end

  describe "#merge_hash(to, from)" do
    context "for shallow hashes" do
      it "should merge two hashes" do

        merged = subject.merge_hash(config_default_yaml, alternate_yaml)
        merged.should be_a Hash
        merged.should have_key(:foo)
        merged.should have_key(:bar)
        merged.should have_key(:columns)
      end

      it "should merge after having merged once." do
        merged = subject.merge_hash(config_default_yaml, alternate_yaml)
        merged = subject.merge_hash(merged, {baz: "!"})
        merged.should be_a Hash
        merged.should have_key(:foo)
        merged.should have_key(:bar)
        merged.should have_key(:columns)
        merged.should have_key(:baz)
      end

      it "should keep the values in the from hash in case of conflict" do
        merged = subject.merge_hash(alternate_yaml, {foo: "result", baz: "!"})
        merged.should have_key(:foo)
        merged.should have_key(:bar)
        merged.should have_key(:baz)
        merged[:foo].should == "result"
      end
    end

    it "should correctly deep merge hashes" do
      merged = subject.merge_hash(config_default_yaml, { columns: {name: {width: "woot"}, age: 10}})
      merged.should have_key(:columns)
      merged[:columns].should have_key(:name)
      merged[:columns].should have_key(:age)
      merged[:columns][:name].should have_key(:width)
      merged[:columns][:name][:width].should == "woot"
    end

    it "should merge ActiveSupport::OrderedOptions" do
      from = ActiveSupport::OrderedOptions.new
      to = ActiveSupport::OrderedOptions.new
      from[:foo] = 1
      to[:bar] = 2
      merged = subject.merge_hash(to, from)
      merged.should be_a ActiveSupport::OrderedOptions
      merged.should have_key(:foo)
      merged.should have_key(:bar)
    end
  end

  describe "add_file_to_hash(old_hash, filename)" do
    after(:all) {subject.on_missing_config_file = :warn}
    it "should return old_hash if filename does not exist." do
      subject.on_missing_config_file = false
      subject.add_file_to_hash(alternate_yaml, 'NONEXISTANT/FILE').should == alternate_yaml
    end

    it "should return merged hash if filename exists." do
      File.stub(:exists?).and_return(true)
      YAML.stub(:load_file).and_return(alternate_yaml)
      merged_hash = subject.add_file_to_hash(config_default_yaml, "FAKE/NAME")
      merged_hash.should have_key(:foo)
      merged_hash.should have_key(:bar)
      merged_hash.should have_key(:columns)
    end
  end


  describe "#load_global_from_file" do
    before(:each) { subject.global_config = subject.mk_default_config }
    after(:all) { subject.global_config = subject.mk_default_config }
    context "when passed with no append flag" do
      before(:each) {subject.global_config[:crushed] = true}
      it "#should replace the existing options with new ones." do
        File.stub(:exists?).and_return(true)
        YAML.stub(:load_file).and_return(alternate_yaml)
        subject.global_config.should have_key(:crushed)
        merged_hash = subject.load_global_from_file("alternate_yaml")
        merged_hash.should_not have_key(:crushed)
        merged_hash.should have_key(:foo)
        merged_hash.should have_key(:bar)
      end
    end

    context "when passed with an append flag" do
      before(:each) {subject.global_config[:crushed] = true}
      it "#should append the new values onto the old" do
        File.stub(:exists?).and_return(true)
        YAML.stub(:load_file).and_return(alternate_yaml)
        subject.global_config.should have_key(:crushed)
        merged_hash = subject.load_global_from_file("alternate_yaml", :append)
        merged_hash.should have_key(:crushed)
        merged_hash.should have_key(:foo)
        merged_hash.should have_key(:bar)
      end
    end
  end

  describe "#global_defaults" do
    before(:each) { subject.global_config = subject.mk_default_config }
    after(:all) { subject.global_config = subject.mk_default_config }

    context "when no global_config file exists" do
      it "should return the default config" do
        File.stub(:exists?).and_return(false)
        $VERBOSE = nil
        merged_hash = subject.global_defaults
        $VERBOSE = false
        merged_hash.keys.length.should == 6
        merged_hash.should_not have_key(:foo)
        merged_hash.should_not have_key(:bar)
        merged_hash.should have_key(:config_dir)
        merged_hash.should have_key(:yaml_extension)
        merged_hash.should have_key(:meta)
      end
    end

    context "when a global_config file exists" do
      it "should return the merged config" do
        File.stub(:exists?).and_return(true)
        YAML.stub(:load_file).and_return(alternate_yaml)
        merged_hash = subject.global_defaults

        merged_hash.keys.length.should == 8
        merged_hash.should have_key(:foo)
        merged_hash.should have_key(:bar)
        merged_hash.should have_key(:config_dir)
        merged_hash.should have_key(:yaml_extension)
        merged_hash.should have_key(:meta)
      end
    end
  end

end


